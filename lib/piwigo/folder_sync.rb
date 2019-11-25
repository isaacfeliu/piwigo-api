require 'logger'
require 'find'
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
      @logger.info "Processing Directory: #{directory}"

      Dir.entries(directory).reject { |entry| entry =~ /^.{1,2}$/ }.each do |directory_entry|
        item_to_process = File.join directory, directory_entry

        if File.directory? item_to_process
          process_directory item_to_process
        else
          process_file item_to_process
        end
      end
    end

    private

    def process_directory(directory_entry)
      @logger.info "Processing #{directory_entry}"
      @parent_album = @current_album
      # Look to see if we have previously created an Album in Piwogo with this name
      @current_album = Piwigo::Albums.lookup(@session, File.basename(directory_entry))

      if @current_album.nil?
        # Album doesn't exist, create one
        new_album = { 'name' => File.basename(directory_entry),
                      'id_uppercat' => @parent_album.nil? ? nil : @parent_album.id }
        album = Piwigo::Albums::Album.new(hash: new_album)
        @current_album = Piwigo::Albums.add @session, album
      end

      # Recursively process all of the entries in this album
      @logger.info "Recursing into #{directory_entry}"
      synchronize directory_entry
    end

    def process_file(directory_entry)
      @logger.info "Processing Image: '#{directory_entry}' in album '#{@current_album}'"
      image = Piwigo::Images.lookup(@session, directory_entry)
      return unless image.nil?

      Piwigo::Images::ImageUploader.new(logger: @logger).upload(@session, directory_entry, File.basename(directory_entry), album: @current_album)
    end
  end
end
