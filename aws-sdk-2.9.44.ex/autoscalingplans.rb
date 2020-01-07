require_relative "client"
require 'active_support/core_ext/hash'
require 'json'
require "uri"

module Aws_sdk_ex

    class AutoScalingPlans < Client_ex

        def initialize(region,aws_key_id,secret_access_key)
            @service_name = "autoscaling-plans"
            @endpoint = "https://autoscaling-plans.%s.amazonaws.com/"
            super
        end


        def describe_scaling_plans(filter)
           
            action = "DescribeScalingPlans"
            apiversin = "2018-01-06"
            body = {
                :Action => action,
                :Version => apiversin
            }
            if filter
                body.update(filter)  
            end  
            body = body.to_json
            resp = send_request("POST","AnyScaleScalingPlannerFrontendService" , action  , "/", "application/x-amz-json-1.1" , body)
            return resp
        end
    end
end

