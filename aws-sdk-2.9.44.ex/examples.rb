require_relative "cloudhsm"
require_relative "route53"



ex = Aws_sdk_ex::CloudHSMV2.new("us-east-2","XXX","XXX")
puts ex.describe_clusters(nil).body
puts ex.describe_clusters(
    {
    :Filters => { 
        :clusterIds => [ "cluster-3e2ofaoqovu" ]
    }
    }  
).body



ex = Aws_sdk_ex::Route53.new("us-east-2","XX","XXXX")
body,resp =  ex.list_hosted_zones(
    {
        :maxitems => 1
    }
)
puts body

ex = Aws_sdk_ex::Route53.new("us-east-2","XX","XXXX")
body,resp =  ex.get_hosted_zone("Z3I3VZLKZJSAO4")
puts body
