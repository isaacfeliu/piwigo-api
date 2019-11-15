require 'net/http'
require 'uri'
require 'json'
require 'logger'

module Piwigo
    # Class to hold the Piwigo session the rest of the API needs to pass in order to access the API
    class Session
        
        def session_id
            @session_id
        end
            
        # Instantion a new  Session object
        # @param [Logger] logger logger to output debug messages to (Optional)
        def initialize(logger: nil)
            @session_id=nil
            @uri=nil       
            @logger = logger || Logger.new(STDOUT)     
        end

        # Log into the piwigo API and grab the session id for subsequent calls.
        # @param [string] piwigo - host to connect to. Can be fqdn or ip. 
        # @param [string] username - user to connect as
        # @param [string] password - password for user
        # @param [boolean] https - Use HTTPS?
        def login(host, username, password, https: true)

            raise "host should not be nil" if host.nil?
            raise "username should not be nil" if username.nil?

            begin
            
                @uri = https ? URI::HTTPS.build(host: host, path: "/ws.php", query: "format=json") :
                               URI::HTTP.build(host: host, path: "/ws.php", query: "format=json")                 
            
                # Create the HTTP objects
                http = Net::HTTP.new(@uri.host, @uri.port)
                request = Net::HTTP::Post.new(@uri.request_uri)
                request.body = "method=pwg.session.login&username=#{username}&password=#{password}"
                
                # Send the request
                response = http.request(request)    
            
                if response.code == '200'
                    @logger.info "Login succeeded: #{response.body}"
                    @session_id = response.response['set-cookie'].split(';').select { |i| i.strip.start_with? "pwg_id" }
                    return true
                else
                    @logger.error "Login failed: #{response.body}"
                    @session_id = nil
                    @uri = nil
                end

            rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
                    @logger.error "Login failed: #{e.messages}"
            end
            false    
        end   
    
        def logout
            raise "login must be successfully called before logout" if @uri.nil?

            # Create the HTTP objects
            http = Net::HTTP.new(@uri.host, @uri.port)
            request = Net::HTTP::Get.new(@uri.request_uri + "&method=pwg.session.logout")
            request['Cookie'] = @session_id
            
            # Send the request
            response = http.request(request)               
            @logger.info "Logout succeeded: #{response.body}" if response.code == '200'    
            @session_id = nil
            @uri = nil
        end
    end
end