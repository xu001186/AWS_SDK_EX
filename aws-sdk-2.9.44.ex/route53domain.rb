require_relative "client"

module Aws_sdk_ex
    class Route53Domains < Client_ex

        def initialize(region,aws_key_id,secret_access_key)
            @service_name = "route53domains"
            @endpoint = "https://route53domains.us-east-1.amazonaws.com/"
            super
        end

        def ListDomains(filter)
            @region = "us-east-1"
            action = "ListDomains"
            body = {
                :Action => action,
                :Version => "2014-05-15"
            }
            if filter
                body.update(filter)  
            end  
            body = body.to_json
            resp = send_request("POST", "Route53Domains_v20140515" , action  , "/","application/x-amz-json-1.1", body)
            return resp
        end

        
        def GetDomainDetail(name)
            @region = "us-east-1"
            action = "GetDomainDetail"
            body = {
                :Action => action,
                :Version => "2014-05-15",
                :DomainName => name
            }
            body = body.to_json
            resp = send_request("POST", "Route53Domains_v20140515" , action  , "/","application/x-amz-json-1.1", body)
            return resp
        end

    end
end
