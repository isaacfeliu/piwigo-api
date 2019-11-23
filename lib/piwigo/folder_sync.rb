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

      Find.find(directory) do |directory_entry|
        next unless directory_entry != directory

        if directory != directory_entry && File.directory?(directory_entry)
          @parent_album = @current_album
          @current_album = Piwigo::Albums::lookup(@session, File.basename(directory_entry))
            if @current_album.nil?
              album = Piwigo::Albums::Album.new(hash: { 'name' =>  File.basename(directory_entry), 
                                                        'id_uppercat' => @parent_album.nil? ? nil : @parent_album.id })
              @current_album = Piwigo::Albums.add @session, album
            end

          synchronize directory_entry
        else
          @logger.info "Processing Image: #{directory_entry} in album '#{@current_album}''"
          image = Piwigo::Images::lookup(@session, directory_entry)
          if image.nil?
            Piwigo::Images::ImageUploader.new(logger: @logger).upload(@session, directory_entry, File.basename(directory_entry))
          end
        end
      end
    end
  end
end