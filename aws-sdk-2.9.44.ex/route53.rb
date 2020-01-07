require_relative "client"
require 'active_support/core_ext/hash'
require 'json'
require "uri"

module Aws_sdk_ex
    class Route53 < Client_ex

        def initialize(region,aws_key_id,secret_access_key)
            @service_name = "route53"
            @endpoint = "https://route53.amazonaws.com/"
            super
        end

        def list_hosted_zones(filter)
            @region = "us-east-1" ## It's the global service 
            action = "hostedzone"
            apiversin = "2013-04-01"
            endpoint = "/%s/%s" % [apiversin,action]
            
            if filter
                endpoint = "#{endpoint}?#{Aws_sdk_ex.hash_to_query(filter)}"
            end

            resp = send_request("GET","" , action  , endpoint ,"rest-xml" , nil)
            parsed_body = ""
            if resp.code == "200"
                resp = send_request("GET","" , action  , endpoint ,"rest-xml" , nil)
                parsed_body = ""
                if resp.code == "200"
                    parsed_body = Hash.from_xml(resp.body).to_json
                end
            end 
            return parsed_body , resp
        end


        def get_hosted_zone(id)
            @region = "us-east-1" ## It's the global service 
            action = "hostedzone"
            apiversin = "2013-04-01"
            endpoint = "/%s/%s/%s" % [apiversin,action,URI.encode_www_form_component(id)]
            resp = send_request("GET","" , action  , endpoint ,"rest-xml" , nil)
            parsed_body = ""
            if resp.code == "200"
                parsed_body = Hash.from_xml(resp.body).to_json
            end 
            return parsed_body , resp
        end
    end
end

