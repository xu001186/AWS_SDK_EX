
require 'uri'
require 'net/http'
require 'json'
require "aws-sigv4"

class Aws_sdk_ex

    attr_reader :service_name
    attr_reader :version
    attr_reader :endpoint
    attr_reader :region   
    attr_reader :aws_key_id   
    attr_reader :secret_access_key   
    

    def initialize(region,aws_key_id,secret_access_key)
        @version = "2017-04-28"
        @region = region
        @aws_key_id = aws_key_id
        @secret_access_key = secret_access_key
       
        if @endpoint
            @endpoint = @endpoint % region
        end
    end

    def send_request(http_method,action,target_name,extra_body)
        signer = Aws::Sigv4::Signer.new(
            service: service_name,
            region: region,
            access_key_id: aws_key_id,
            secret_access_key: secret_access_key,
            unsigned_headers: ['content-length', 'user-agent', 'x-amzn-trace-id']
          )

        body = {
            :Action => action,
            :Version => version
        }
        if extra_body
            body.update(extra_body)  
        end   
        body = body.to_json
        signature = signer.sign_request(
            http_method: http_method,
            url: endpoint,
            body: body
        )
        uri = URI.parse(endpoint)
        https = Net::HTTP.new(uri.host,uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request.add_field 'Host', signature.headers['host']
        request.add_field 'x-amz-date', signature.headers['x-amz-date']
        request.add_field 'X-Amz-Content-Sha256', signature.headers['x-amz-content-sha256']
        request.add_field 'Authorization', signature.headers['authorization']
        request.add_field 'X-Amz-Target', "%s.%s" % [target_name,action]
        request["Content-Type"] = "application/x-amz-json-1.1"
        request.body = body
        res = https.request(request)
        return res
    end
  end
  
