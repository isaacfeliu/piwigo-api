require 'logger'
require 'find'
require 'exifr/jpeg'
require_relative 'albums'
require_relative 'image_uploader'

module Piwigo
  # Syncronize a folder with Piwigo
  #    - Album name will be the same as the folder name
  #    - Will be created as a top-level folder unless specified
  class FolderSync
    # Create a new ImageUploader
    #
    # @param [Session] session - session to a piwigo instance
    def initialize(session, logger: nil)
      @logger = logger || Logger.new(STDOUT)
      @session = session
      @current_album = nil
      @parent_album = nil
    end

    def self.synchronize(session, directory, logger: nil)
      unless File.directory?(directory)
        @Logger.error "No such directory: #{directory}"
        return false
      end
      FolderSync.new(session, logger: logger).synchronize(directory)
    end

    # Syncronize a folder with Piwigo
    #
    # @param [String] directory - directory to  syncronize.
    def synchronize(directory)
      if ['originals', '.picasaoriginals'].include? File.basename(directory.downcase)
        @logger.info "Skipping special directory: #{directory}"
        return
      else
        @logger.info "Processing Directory: #{directory}"
      end

      Dir.entries(directory).reject { |entry| entry =~ /^.{1,2}$/ }.each do |directory_entry|
        item_to_process = (File.join directory, directory_entry).encode('utf-8')

        if File.directory? item_to_process
          @parent_album = ensure_album(File.dirname(item_to_process), nil)
          @current_album = ensure_album(item_to_process, @parent_album)

          # Recursively process all of the entries in this album
          synchronize item_to_process
        else
          process_file item_to_process
        end
      end
    end

    private

    def ensure_album(directory_entry, parent_album)
      album_name = File.basename(directory_entry)
      @logger.info "Ensuring Album #{album_name} exits"
      return if ['/', '\\', ''].include? album_name

      # Look to see if we have previously created an Album in Piwigo with this name
      album = Piwigo::Albums.lookup(@session, album_name)

      if album.nil?
        # Album doesn't exist, create one
        new_album = { 'name' => album_name,
                      'id_uppercat' => parent_album.nil? ? nil : parent_album.id }
        album = Piwigo::Albums::Album.new(hash: new_album)
        album = Piwigo::Albums.add @session, album
      end
      album
    end

    def process_file(directory_entry)
      # Only attempt to import images
      return unless ['.jpg', '.png', '.gif'].include? File.extname(directory_entry).downcase

      @logger.info "Processing Image: '#{directory_entry}' in album '#{@current_album}'"
      image = Piwigo::Images.lookup(@session, directory_entry)
      return unless image.nil?

      Piwigo::Images::ImageUploader.new(logger: @logger).upload(@session, directory_entry, File.basename(directory_entry), album: @current_album)
    end
  end
end
