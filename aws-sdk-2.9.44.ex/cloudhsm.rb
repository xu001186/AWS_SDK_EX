require_relative "client"
module Aws_sdk_ex
    class CloudHSMV2 < Client_ex

        def initialize(region,aws_key_id,secret_access_key)
            @service_name = "cloudhsm"
            @endpoint = "https://cloudhsmv2.%s.amazonaws.com/"
            super
        end


        def describe_clusters(filter)
            action = "DescribeClusters"
            body = {
                :Action => action,
                :Version => "2017-04-28"
            }
            if filter
                body.update(filter)  
            end  
            body = body.to_json
            resp = send_request("POST","BaldrApiService",action, "/", "application/x-amz-json-1.1" , body)
            return resp
        end    

    end
end


