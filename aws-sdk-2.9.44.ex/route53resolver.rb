require_relative "client"
module Aws_sdk_ex
    class Route53Resolver < Client_ex

        def initialize(region,aws_key_id,secret_access_key)
            @service_name = "route53resolver"
            @endpoint = "https://route53resolver.%s.amazonaws.com/"
            super
        end

        def ListResolverRules(filter)
            action = "ListResolverRules"
            body = {
                :Action => action,
                :Version => "2018-04-01"
            }
            if filter
                body.update(filter)  
            end  
            body = body.to_json
            resp = send_request("POST", "Route53Resolver" , action  , "/","application/x-amz-json-1.1", body)
            return resp
        end

        
        def GetResolverRule( id )
            action = "GetResolverRule"
            body = {
                :Action => action,
                :Version => "2018-04-01",
                :ResolverRuleId => id

            }

            body = body.to_json
            resp = send_request("POST", "Route53Resolver" , action  , "/","application/x-amz-json-1.1", body)
            return resp
        end

    end
end
