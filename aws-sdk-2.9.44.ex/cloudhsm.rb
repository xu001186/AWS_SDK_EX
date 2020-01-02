require_relative "client"

class Cloudhsm_ex < Aws_sdk_ex

    def initialize(region,aws_key_id,secret_access_key)
        @service_name = "cloudhsm"
        @endpoint = "https://cloudhsmv2.%s.amazonaws.com/"
        super
    end

    def DescribeClusters()
        resp = send_request("POST","DescribeClusters","BaldrApiService",nil)
        puts resp.body
    end
    
end


ex = Cloudhsm_ex.new("us-east-2","XX","XXXX")
ex.DescribeClusters()