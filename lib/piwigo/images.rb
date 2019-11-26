require 'base64'
require 'net/http'
require 'uri'
require 'json'
require 'logger'
require 'digest'
require_relative 'image_uploader'

# Piwigo organizes images by albums. The album tree has unlimted depth and each photo can belong to multiple albums. The Piwigo API
# refers to a Album as a Category.
module Piwigo
  class Images
    class Image
      # @return [Number] Unique ID idenifying this ie
      attr_accessor :id

      # @return [Number] Width of the image in pixels
      attr_accessor :width

      # @return [Number] Height of the image in pixels
      attr_accessor :height

      # @return [Number] Number of times the image has been viewed
      attr_accessor :hit

      # @return [String] Filename for the image
      attr_accessor :file

      # @return [String] Name of the image
      attr_accessor :name

      # @return [String] Comments about the image
      attr_accessor :comment

      # @return [DateTime] DateTime when the image was taken
      attr_accessor :date_creation

      # @return [DateTime] DateTime when the image was uploaded to Piwigo
      attr_accessor :date_available

      # @return [String] URL to the image page
      attr_accessor :page_url

      # @return [String] URL to the image itself
      attr_accessor :element_url

      # @return [Array<String>] Links to different sizes of the image
      attr_accessor :derivatives

      # @return [<Type>] List of all of the Albums this image is in
      attr_accessor :categories

      def initialize(hash: nil)
        hash&.each do |key, value|
          # Bug: If the encoding is Windows-1252, then Piwigo will blowup when creating the album
          value = value.encode('UTF-8', 'Windows-1252') if value.class == String && value.encoding.to_s == 'Windows-1252'
          send("#{key}=", value)
        end
      end
    end

    class Paging
      # @return [Number] Page number of the results
      attr_accessor :page

      # @return [Number] Number of images requesed per page
      attr_accessor :per_page

      # @return [Number] Number of Images on this page. When this is less then the number per page, then there are no more results.
      attr_accessor :count

      # @return [Number] Total number of images across all pages
      attr_accessor :total_count

      def initialize(hash: nil)
        hash&.each do |key, value|
          # Bug: If the encoding is Windows-1252, then Piwigo will blowup when creating the album
          value = value.encode('UTF-8', 'Windows-1252') if value.class == String && value.encoding.to_s == 'Windows-1252'
          send("#{key}=", value)
        end
      end
    end

    # Returns elements for the corresponding categories.
    # order comma separated fields for sorting
    #
    # @param [Session] session
    # @param [Number] album_id - Can be empty if recursive is true.
    # @param [Boolean] recursive - Include images from child albums
    # @param [Number] per_page - Number of items to include per page
    # @param [Number] page - Page to retrieve
    # @param [String] order - One or more of id, file, name, hit, rating_score, date_creation, date_available or random
    # @param [Logger] logger logger to output debug messages to (Optional)
    #
    # @return [Hash] <description>
    def self.getImages(session, album_id: nil, recursive: nil, per_page: 100, page: 0, order: nil, logger: nil)
      raise 'Invalid session' if session.uri.nil?

      logger ||= Logger.new(STDOUT)

      begin
        http = Net::HTTP.new(session.uri.host, session.uri.port)
        request = Net::HTTP::Post.new(session.uri.request_uri)
        form = {
          method: 'pwg.categories.getImages'
        }
        form[:cat_id] = album_id unless album_id.nil?
        form[:recursive] = recursive unless recursive.nil?
        form[:per_page] = per_page unless per_page.nil?
        form[:order] = order unless order.nil?
        form[:page] = page unless page.nil?
        request.set_form_data(form)
        request['Cookie'] = [session.id]

        # Send the request
        response = http.request(request)
        if response.code == '200'
          data = JSON.parse(response.body)
          paging = Paging.new hash: data['result']['paging']
          images = data['result']['images'].map { |hash| Image.new(hash: hash) }
          logger.info "Image List succeeded: #{images.size} images retrieved."
          { paging: paging, images: images }
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        logger.error "Image List failed: #{e.message}"
        nil
      end
    end

    # Add a photo to Piwigo
    #
    # @param [<Type>] session
    # @param [<Type>] filename of the file to upload
    # @param [<Type>] name of the image
    #
    # @return [Boolean] True if successful
    def self.upload(session, file, name)
      ImageUploader.new(session, file, name).upload
    end

    # Checks existence of images
    #
    # @param [Session] session
    # @param [String] file to check
    # @param [Logger] logger
    #
    # @return [Number] Piwigo image_id if matched, nil if not present
    def self.lookup(session, file, logger: nil)
      raise 'Invalid session' if session.uri.nil?

      logger ||= Logger.new(STDOUT)
      image_content = File.binread(file)
      file_sum = Digest::MD5.hexdigest(image_content)

      begin
        http = Net::HTTP.new(session.uri.host, session.uri.port)
        request = Net::HTTP::Post.new(session.uri.request_uri)
        form = {
          method: 'pwg.images.exist',
          md5sum_list: file_sum,
          filename_list: file
        }
        request.set_form_data(form)
        request['Cookie'] = [session.id]

        # Send the request
        response = http.request(request)
        if response.code == '200'
          data = JSON.parse(response.body)
          logger.info "Image lookup succeeded: #{data['result']}"
          data['result'][file_sum]
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        logger.error "Image lookup failed: #{e.message}"
        nil
      end
    end
  end
end
