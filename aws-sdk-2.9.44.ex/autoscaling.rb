require_relative "client"
require 'active_support/core_ext/hash'
require 'json'
require "uri"

module Aws_sdk_ex

    class AutoScaling < Client_ex

        def initialize(region,aws_key_id,secret_access_key)
            @service_name = "autoscaling"
            @endpoint = "https://autoscaling.%s.amazonaws.com/"
            super
        end


        def describe_auto_scaling_groups(filter)
            action = "DescribeAutoScalingGroups"
            apiversin = "2011-01-01"
            if filter
                filter.update({
                    :Action => action,
                    :Version => apiversin
                })
            else
                filter = {
                    :Action => action,
                    :Version => apiversin                    
                }
            end
            
            endpoint = "#{endpoint}?#{Aws_sdk_ex.hash_to_query(filter)}"
            
            resp = send_request("GET","" , action  , endpoint ,"rest-xml" , nil)
            parsed_body = ""
            if resp.code == "200"
                parsed_body = Hash.from_xml(resp.body).to_json
            end
            return parsed_body , resp
        end
    end
end

