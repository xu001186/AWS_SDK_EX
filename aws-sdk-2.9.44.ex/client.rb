
require 'uri'
require 'net/http'
require 'json'
require "aws-sigv4"

module Aws_sdk_ex
    class Aws_sdk_ex

        attr_reader :service_name
        attr_reader :endpoint
        attr_reader :region   
        attr_reader :aws_key_id   
        attr_reader :secret_access_key   
        attr_reader :client
        

        def initialize(region,aws_key_id,secret_access_key)
            @region = region
            @aws_key_id = aws_key_id
            @secret_access_key = secret_access_key
            ## be to compatible with the aws sdk resource.client
            @client = self
            if @endpoint
                @endpoint = @endpoint % region
            end
        end


        def send_request(http_method,target_name,action,uri,content_type ,extra_body )
            http_method = http_method.capitalize()
            signer = Aws::Sigv4::Signer.new(
                service: service_name,
                region: region,
                access_key_id: aws_key_id,
                secret_access_key: secret_access_key,
                unsigned_headers: ['content-length', 'user-agent', 'x-amzn-trace-id']
            )
            new_endpoint = URI.join(endpoint,uri).to_s
            signature = signer.sign_request(
                http_method: http_method,
                url: new_endpoint,
                body: extra_body
            )
            uri = URI.parse(new_endpoint)
            https = Net::HTTP.new(uri.host,uri.port)
            https.use_ssl = true
            request = Net::HTTP.const_get(http_method).new(uri.request_uri)
            request.add_field 'Host', signature.headers['host']
            request.add_field 'x-amz-date', signature.headers['x-amz-date']
            request.add_field 'X-Amz-Content-Sha256', signature.headers['x-amz-content-sha256']
            request.add_field 'Authorization', signature.headers['authorization']
            request.add_field 'X-Amz-Target', "%s.%s" % [target_name,action]
            request["Content-Type"] = content_type
            request.body = extra_body
            res = https.request(request)
            return res
        end

         ## To be compatible with the aws sdk client.config
        def config()
            return {
                :region => region 
            }
        end

    end

end
