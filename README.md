The ManangeIQ is using the aws sdk 2.9.44 for aws discover , some of the new aws resource types are not supported by sdk 2.9.44.

This repo is used for directly calling the AWS REST API to support new resource types .


How to run the example?
```

ex = Aws_sdk_ex::CloudHSMV2.new("us-east-2","XXX","XXX")
puts ex.describe_clusters(nil).body
puts ex.describe_clusters(
    {
    :Filters => { 
        :clusterIds => [ "cluster-3e2ofaoqovu" ]
    }
    }  
).body

```
