require_relative "client"
require "nokogiri"
require "uri"

module Aws_sdk_ex
    class Route53 < Aws_sdk_ex

        def initialize(region,aws_key_id,secret_access_key)
            @service_name = "route53"
            @endpoint = "https://route53.amazonaws.com/"
            super
        end

        def read_content(xpath_result)
            return nil unless xpath_result && xpath_result.count > 0
            return xpath_result[0].content
        end

        def hostzone_xml_to_json(hostzone)
            return {
                :Id => read_content(hostzone.xpath(".//Id")).split("/")[-1],
                :Name => read_content(hostzone.xpath(".//Name")),
                :CallerReference => read_content(hostzone.xpath(".//CallerReference")),
                :Config => {
                   :PrivateZone => read_content(hostzone.xpath(".//Config/PrivateZone")),
                   :Comment => read_content(hostzone.xpath(".//Config/Comment"))
                },
                :ResourceRecordSetCount => read_content(hostzone.xpath(".//ResourceRecordSetCount")),
                :LinkedService => {
                    :Description => read_content(hostzone.xpath(".//LinkedService/Description")),
                    :ServicePrincipal => read_content(hostzone.xpath(".//LinkedService/ServicePrincipal"))
                }
            }
        end

        def list_hosted_zones(filter)
            @region = "us-east-1" ## It's the global service 
            action = "hostedzone"
            apiversin = "2013-04-01"
            endpoint = "/%s/%s" % [apiversin,action]
            
            if filter
                param = filter.collect do |k,v|
                    out = ""
                    if v.kind_of?(Hash)
                      v.each do |kk,vv|
                        out += "#{k}.#{kk}=#{vv}"
                      end
                    else
                      out += "#{k}=#{v}"
                    end
                    out
                    end.join("&")
                    endpoint = "#{endpoint}?#{param}"
            end
            resp = send_request("GET","" , action  , endpoint ,"rest-xml" , nil)
            parsed_body = ""
            if resp.code == "200"
                hostzones_doc = Nokogiri.XML(resp.body)
                json_hostzone_lst = []
                hostzones_doc.remove_namespaces!
                hostzones_doc.xpath('//HostedZone').each do | hostzone |
                    json_hostzone = hostzone_xml_to_json(hostzone)
                    json_hostzone_lst.append(json_hostzone)
                end
                json_resp_content = {
                    :HostedZones => json_hostzone_lst,
                    :Marker => read_content(hostzones_doc.xpath("//Marker")),
                    :NextMarker => read_content(hostzones_doc.xpath("//NextMarker")),
                    :MaxItems => read_content(hostzones_doc.xpath("//MaxItems")),
                    :IsTruncated => read_content(hostzones_doc.xpath("//IsTruncated"))
                }.to_json
                parsed_body = json_resp_content
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
                hostzones_doc = Nokogiri.XML(resp.body)
                 
                hostzones_doc.remove_namespaces!
                hostzones_doc.xpath('//HostedZone').each do | hostzone |
                    parsed_body = hostzone_xml_to_json(hostzone)
                end
                parsed_body = parsed_body.to_json
            end
                
            return parsed_body , resp
        end
    end
end

