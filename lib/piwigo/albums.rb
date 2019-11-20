require 'net/http'
require 'uri'
require 'json'
require 'logger'

# Piwigo organizes images by albums. The album tree has unlimted depth and each photo can belong to multiple albums. The Piwigo API
# refers to a Album as a Category.
module Piwigo
  class Albums
    class Album
      # @return [Number] Album ID
      attr_accessor :id

      # @return [String] Name of the Album
      attr_accessor :name

      # @return [String] Album Description
      attr_accessor :comment

      # ???
      attr_accessor :permalink

      # @return [String] public or private
      attr_accessor :status

      # ???
      attr_accessor :uppercats

      # The rank of an album
      attr_accessor :global_rank

      # @return [Number] ID of the parent album, nil of this is a top-level album (Aka ParentID)
      attr_accessor :id_uppercat

      # @return [Number] Number of the Newest photos, excluding child albums
      attr_accessor :nb_images

      # @return [Number] Number of the Newest photos, including child albums
      attr_accessor :total_nb_images

      # ID of the representative photo for an album. This photo doesn't have to belong to the album.
      attr_accessor :representative_picture_id

      # @return [DateTime] Date of the Newest photos, excluding child albums
      attr_accessor :date_last

      # @return [DateTime] Date of the Newest photos, including child albums
      attr_accessor :max_date_last

      # @return [Number] Number of child albums inside this album
      attr_accessor :nb_categories

      # @return [Atring] Album URL
      attr_accessor :url

      # @return [String] Thumbnail URL
      attr_accessor :tn_url

      def initialize(hash: nil)
        hash&.each { |key, value| send("#{key}=", value) }
      end
    end

    # Returns a list of albums
    #
    # @param [Session] session - Session
    # @param [Number] album_id - Album to fetch, Optional
    # @param [Boolean] recursive - Include subalbums, Optional
    # @param [Boolean] public - Only include public albums, Optional
    # @param [Boolean] fullname - ???, Optional
    # @param [String] thumbnail_size - Size of thumbname to return, One of: square, thumb, 2small, xsmall, small, medium, large, xlarge, xxlarge. Optional
    # @param [Logger] logger logger to output debug messages to (Optional)
    #
    # @return [Array<Album>] All albums that match the criteria, or nil there were no matches
    def self.list(session, album_id: nil, recursive: false, public: false, fullname: false, thumbnail_size: 'thumb', logger: nil)
      raise 'Invalid session' if session.uri.nil?

      logger ||= Logger.new(STDOUT)

      begin
        http = Net::HTTP.new(session.uri.host, session.uri.port)
        request = Net::HTTP::Post.new(session.uri.request_uri)
        request.body = "method=pwg.categories.getList&cat_id=#{album_id}&recursive=#{recursive}&public=#{public}&fullname=#{fullname}&thumbnail_size=#{thumbnail_size}"
        request['Cookie'] = [session.id]

        # Send the request
        response = http.request(request)
        if response.code == '200'
          data = JSON.parse(response.body)
          albums = data['result']['categories'].map { |hash| Album.new(hash: hash) }
          logger.info "Album List succeeded: #{albums.size} albums retrieved."
          albums
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        logger.error "Album List failed: #{e.messages}"
        nil
      end
    end

    # Adds an album.
    #
    # @param [Session] session to interact with Piwigo
    # @param [Album] album album to create
    # @param [Logger] logger logger to output debug messages to (Optional)
    #
    # @return [Album] newly created album
    def self.add(session, album, logger: nil)
      raise 'Invalid session' if session.uri.nil?
      raise 'Invalid album' if album.nil?

      logger ||= Logger.new(STDOUT)

      begin
        http = Net::HTTP.new(session.uri.host, session.uri.port)
        request = Net::HTTP::Post.new(session.uri.request_uri)
        request.body = "method=pwg.categories.add&name=#{album.name}"
        request.body.concat "&parent=#{album.id_uppercat}" unless album.id_uppercat.nil?
        request.body.concat "&comment=#{album.comment}" unless album.comment.nil?
        request.body.concat "&status=#{album.status}" unless album.status.nil?
        request['Cookie'] = [session.id]

        # Send the request
        response = http.request(request)
        if response.code == '200'
          data = JSON.parse(response.body)
          album.id = data['result']['id']
          logger.info "Album Add succeeded: #{album.id} created."
          album
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        logger.error "Album Add failed: #{e.messages}"
        nil
      end
    end

    # Deletes album(s).
    #
    # @param [Session] piwigo session
    # @param [Number] id of the album to remove
    # @param [String] photo_deletion_mode can be "no_delete" (may create orphan photos), "delete_orphans" (default mode, only deletes photos linked to no other album)
    #                 or "force_delete" (delete all photos, even those linked to other albums)
    # @param [Logger] logger logger to output debug messages to (Optional)
    #
    # @return [Boolean] true if album was deleted
    def self.delete(session, id, photo_deletion_mode: nil, logger: nil)
      raise 'Invalid session' if session.uri.nil?

      logger ||= Logger.new(STDOUT)

      begin
        http = Net::HTTP.new(session.uri.host, session.uri.port)
        request = Net::HTTP::Post.new(session.uri.request_uri)
        request.body = "method=pwg.categories.delete&category_id=#{id}"        
        request.body.concat "&photo_deletion_mode=#{photo_deletion_mode}" unless photo_deletion_mode.nil?
        request.body.concat "&pwg_token=#{session.pwg_token}"
        request['Cookie'] = [session.id]

        # Send the request
        response = http.request(request)
        if response.code == '200'
          data = JSON.parse(response.body)
          logger.info "Album Delete succeeded: #{data}"
          true
        else
          p response.code
          p response.body
          false

        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        logger.error "Album delete: #{e.messages}"
        false
      end
    end
  end
end
