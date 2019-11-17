require 'net/http'
require 'uri'
require 'json'
require 'logger'

module Piwigo
    # Class to hold the Piwigo session the rest of the API needs to pass in order to access the API
    class Session
        
        # @return [String] Piwigo session cookie
        attr_accessor :id

        # @return [URI::HTTP] Piwigo host associated with this session
        attr_accessor :uri

        # @return [String] token required for admin methods
        attr_accessor :pwg_token

        # @return [String] token required for admin methods
        attr_accessor :username


        def initialize(id, uri)
            self.id = id
            self.uri = uri

            status            
        end
          
        # Gets information about the current session. Also provides a token useable with admin methods.
        # {"stat":"ok","result":{"username":"Adrian","status":"webmaster","theme":"modus","language":"en_GB","pwg_token":"9edde6a1ae535934cca6a2423f9bcbe7","charset":"utf-8","current_datetime":"2019-11-17 21:57:58","version":"2.10.1","available_sizes":["square","thumb","2small","xsmall","small","medium","large","xlarge","xxlarge"],"upload_file_types":"jpg,jpeg,png,gif","upload_form_chunk_size":500}}
        # @return [<Type>] <description>
        def status
            logger = logger || Logger.new(STDOUT)     

            begin                       
                # Create the HTTP objects
                http = Net::HTTP.new(uri.host, uri.port)
                request = Net::HTTP::Post.new(uri.request_uri)
                request.body = "method=pwg.session.getStatus"
                request['Cookie'] = self.id
                
                # Send the request
                response = http.request(request)    
            
                if response.code == '200'
                    logger.info "Status succeeded"
                    data = JSON.parse(response.body)
                    self.pwg_token = data['result']['pwg_token']
                    self.username = data['result']['username']
                end

            rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
                    logger.error "Unexpected failed: #{e.messages}"
            end
            nil              
            
        end
           
        # Logout of the current session
        # @param [Logger] logger logger to output debug messages to (Optional)        
        def logout(logger: nil)            
            raise "This session has already been logged out" if uri.nil?
            logger = logger || Logger.new(STDOUT)     

            # Create the HTTP objects
            http = Net::HTTP.new(self.uri.host, self.uri.port)
            request = Net::HTTP::Get.new(self.uri.request_uri + "&method=pwg.session.logout")
            request['Cookie'] = self.id
            
            # Send the request
            response = http.request(request)               
            logger.info "Logout succeeded: #{response.body}" if response.code == '200'    
            self.id = nil
            self.uri = nil
        end
        
        
        # Log into the piwigo API and grab the session id for subsequent calls.
        # @param [string] piwigo - host to connect to. Can be fqdn or ip. 
        # @param [string] username - user to connect as
        # @param [string] password - password for user
        # @param [boolean] https - Use HTTPS?
        # @param [Logger] logger logger to output debug messages to (Optional)        
        def self.login(host, username, password, https: true, logger: nil)

            raise "host should not be nil" if host.nil?
            raise "username should not be nil" if username.nil?
            logger = logger || Logger.new(STDOUT)     

            begin
            
                uri = https ? URI::HTTPS.build(host: host, path: "/ws.php", query: "format=json") :
                                   URI::HTTP.build(host: host, path: "/ws.php", query: "format=json")                 
            
                # Create the HTTP objects
                http = Net::HTTP.new(uri.host, uri.port)
                request = Net::HTTP::Post.new(uri.request_uri)
                request.body = "method=pwg.session.login&username=#{username}&password=#{password}"
                
                # Send the request
                response = http.request(request)    
            
                if response.code == '200'
                    logger.info "Login succeeded: #{response.body}"
                    pwg_id = response.response['set-cookie'].split(';').select { |i| i.strip.start_with? "pwg_id" }.first
                    return Session.new(pwg_id, uri)
                else
                    logger.error "Login failed: #{response.body}"
                end

            rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
                    logger.error "Login failed: #{e.messages}"
            end
            nil                
        end       
    end
end