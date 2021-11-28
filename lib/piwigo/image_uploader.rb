require 'net/http'
require 'uri'
require 'json'
require 'logger'
require 'digest'
require 'base64'

# Add a photo.
#
# To avoid limitations on HTTP POST maximum size, the piwigo requires the image to be splitted into several calls to pwg.images.addChunk 
# and then a single call to pwg.images.add.
#
# Reference: https://piwigo.org/doc/doku.php?id=dev:webapi:pwg.images.add
module Piwigo
  class Images
    class ImageUploader
      MEGABYTE = 1024 * 1024

      # Create a new ImageUploader
      #
      # @param [Session] session - session to a piwigo instance
      def initialize(logger: nil)
        @logger = logger || Logger.new(STDOUT)
      end

      # Add a photo to Piwigo
      #
      # @param [<Type>] session
      # @param [<Type>] filename of the file to upload
      # @param [<Type>] name of the image
      #
      # @return [Boolean] True if successful
      def upload(session, filename, name, album: null)
        @session = session
        raise 'Invalid session' if @session.uri.nil?

        unless File.exist? filename
          @Logger.error "No such file: #{filename}"
          return false
        end
        chunk_num = 0
        image_content = File.binread(filename)
        original_sum = Digest::MD5.hexdigest(image_content)
        encoded_content = image_content
        io = StringIO.new(encoded_content)
        until io.eof?
          chunk = io.read(MEGABYTE)
          addChunk(chunk, original_sum, chunk_num)
          chunk_num += 1
        end
        attributes = sniff_attributes(filename, album: album)
        add(original_sum, filename, name, attributes: attributes)
      end

      private

      # Add a chunk of a file.
      #
      # @param [String] data - substring of the base64 encoded binary file
      # @param [String] original_sum - md5sum of the original photo, used as a unique identifier, not to check the chunk upload
      # @param [Number] position -  the numeric position of the chunk among all chunks of the given file
      #
      # @return [Boolean] true if successful
      def addChunk(data, original_sum, position)
        http = Net::HTTP.new(@session.uri.host, @session.uri.port)
        http.use_ssl = session.uri.scheme == 'https'
        request = Net::HTTP::Post.new(@session.uri.request_uri)
        form = {
          method: 'pwg.images.addChunk',
          original_sum: original_sum,
          position: position,
          data: Base64.encode64(data)
        }
        request.set_form_data(form)
        request['Cookie'] = [@session.id]

        response = http.request(request)
        if response.code == '200'
          data = JSON.parse(response.body)
          @logger.info "Image AddChunk ##{position} succeeded: #{data}"
          true
        else
          false
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        @logger.error "Image AddChunk failed: #{e.message}"
        false
      end

      # Add an image. Pwg.images.addChunk must have been called before (maybe several times).
      #
      # @param [<Type>] original_sum - md5sum that makes the photo unique
      # @param [<Type>] original_filename
      # @param [<Type>] name
      # @param [Hash] attributes - attributes to include with image add. Include:
      #    author
      #    level - 0 (—-), 1 (Contacts), 2 (Friends), 4 (Family), 8 (Admins)
      #    date_creation - formatted as 2009-03-26
      #    comment -
      #    categories - list of category identifiers where you want the photo to be shown. Optionaly, you can set a rank inside the each category.
      #                 Example : '19,3;16,0;134' will associate the photo to category 19 at rank 3, to category 16 at rank 0 (first position) and
      #                           to category 134 with an automatic rank (last position).
      #    image_id - give an image_id if you want to update an existing photo
      #
      # @return [Boolean] True if successful
      def add(original_sum, original_filename, name, attributes: {})

        # name, author: nil, level: nil, date_creation: nil, comment: nil, categories: nil, image_id: nil

        http = Net::HTTP.new(@session.uri.host, @session.uri.port)
        http.use_ssl = @session.uri.scheme == 'https'
        request = Net::HTTP::Post.new(@session.uri.request_uri)
        form = {
          method: 'pwg.images.add',
          original_sum: original_sum,
          original_filename: original_filename,
          name: name
        }

        form[:author] = attributes[:author] if attributes.key? :author
        form[:level] = attributes[:level] if attributes.key? :level
        form[:date_creation] = attributes[:date_creation] if attributes.key? :date_creation
        form[:comment] = comment attributes[:comment] if attributes.key? :comment
        form[:categories] = attributes[:categories] if attributes.key? :categories
        form[:image_id] = attributes[:image_id] if attributes.key? :image_id
        request.set_form_data(form)

        request['Cookie'] = [@session.id]

        response = http.request(request)
        if response.code == '500'
          @logger.error "Image Add failed: #{response.message}"
          false
        elsif response.code == '200'
          data = JSON.parse(response.body)
          p data
          @logger.info 'Image Add succeeded.'
          true
        else
          false
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        @logger.error "Image Add failed: #{e.message}"
        false
      end

      def sniff_attributes(filename, album: nil)
        attributes = {}
        begin         
          info = EXIFR::JPEG.new(filename)
          @logger.info "--> GPS: #{info.gps.latitude}, #{info.gps.longitude}" unless info.gps.nil?
          exif = info.exif.first.to_hash if info.exif?
          if exif.nil?
            # No EXIF data, use the file ctime as the date_creation
            fs = File::Stat.new(filename)
            @logger.info "--> File::Stat: #{fs.inspect}"
            attributes[:date_creation] = fs.ctime.strftime('%Y-%m-%d')
          elsif exif.key?(:date_time_original)
            # We have EXIF data, pull out the date_time_original for the date_creation
            attributes[:date_creation] = exif[:date_time_original].strftime('%Y-%m-%d')

            # if !exif.key? :date_time_original do
            #   exif.each do |item|
            #     @logger.info "--> #{item[0]}: #{item[1]}"
            #   end
            # end
          end
        rescue EXIFR::MalformedJPEG => e
          @logger.error e.message
        end

        attributes[:categories] = album.id unless album.nil?
        @logger.info attributes
        attributes
      end
    end


  end
end
