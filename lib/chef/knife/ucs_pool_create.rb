# Author:: Murali Raju (<murali.raju@appliv.com>)
# Author:: Velankani Engineering <eng@velankani.net>
# Copyright:: Copyright (c) 2012 Murali Raju.
# Copyright:: Copyright (c) 2012 Velankani Information Systems, Inc
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'chef/knife/ucs_base'

class Chef
  class Knife
    class UcsPoolCreate < Knife

      include Knife::UCSBase
      
      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end      

      banner "knife ucs pool create (options)"
      
      option :pooltype,
        :long => "--pool-type POOLTYPE",
        :description => "UCS pool types <mac,uuid,wwpn,wwnn,managementip>",
        :proc => Proc.new { |f| Chef::Config[:knife][:pooltype] = f }

      option :name,
        :long => "--pool-name POOLNAME",
        :description => "The pool name",
        :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }

      option :start,
        :long => "--pool-start STARTRANGE",
        :description => "Start of a pool range <IP, WWPN, WWNN, MAC>",
        :proc => Proc.new { |f| Chef::Config[:knife][:start] = f }

      option :end,
        :long => "--pool-end ENDRANGE",
        :description => "End of a pool range <IP, WWPN, WWNN, MAC>",
        :proc => Proc.new { |f| Chef::Config[:knife][:end] = f }


      option :mask,
        :long => "--subnet-mask SUBNETMASK",
        :description => "The subnet mask for an IP range",
        :proc => Proc.new { |f| Chef::Config[:knife][:mask] = f }

      option :gateway,
        :long => "--gateway IPGATEWAY",
        :description => "The IP Gateway address of a subnet",
        :proc => Proc.new { |f| Chef::Config[:knife][:gateway] = f }

      option :org,
        :long => "--org ORG",
        :description => "The organization",
        :proc => Proc.new { |f| Chef::Config[:knife][:org] = f }      

      def run
        $stdout.sync = true
          
        pool_type = "#{Chef::Config[:knife][:pooltype]}".downcase
        case pool_type
        when 'managementip'
          json = { :start_ip => Chef::Config[:knife][:start],   :end_ip => Chef::Config[:knife][:end],
                   :subnet_mask => Chef::Config[:knife][:mask], :gateway => Chef::Config[:knife][:gateway] }.to_json
          
          xml_response = provisioner.set_management_ip_pool(json)
          xml_doc = Nokogiri::XML(xml_response)
  
          xml_doc.xpath("configConfMos/outConfigs/pair/ippoolBlock").each do |ippool|
            puts ''
            puts "Management IP Block from: #{ui.color("#{ippool.attributes['from']}", :blue)} to: #{ui.color("#{ippool.attributes['to']}", :blue)}" + 
                  " status: #{ui.color("#{ippool.attributes['status']}", :green)}"
          end

          
          xml_doc.xpath("configConfMos").each do |ippool|
             puts "#{ippool.attributes['errorCode']} #{ui.color("#{ippool.attributes['errorDescr']}", :red)}"
          end
          
        when 'mac'
          json =  { :mac_pool_name => Chef::Config[:knife][:name],  :mac_pool_start => Chef::Config[:knife][:start], 
                    :mac_pool_end => Chef::Config[:knife][:end],    :org => Chef::Config[:knife][:org] }.to_json
          
          xml_response = provisioner.set_mac_pool(json)
          xml_doc = Nokogiri::XML(xml_response)
  
          xml_doc.xpath("configConfMos/outConfigs/pair/macpoolPool").each do |macpool|
            puts ''
            puts "MAC address pool : #{ui.color("#{macpool.attributes['name']}", :blue)}" + 
                  " status: #{ui.color("#{macpool.attributes['status']}", :green)}"
          end

          
          xml_doc.xpath("configConfMos").each do |macpool|
             puts "#{macpool.attributes['errorCode']} #{ui.color("#{macpool.attributes['errorDescr']}", :red)}"
          end          

        when 'wwnn'
          json =  { :wwnn_name => Chef::Config[:knife][:name],  :wwnn_from => Chef::Config[:knife][:start], 
                    :wwnn_to => Chef::Config[:knife][:end],     :org => Chef::Config[:knife][:org] }.to_json
          
          xml_response = provisioner.set_wwnn_pool(json)
          xml_doc = Nokogiri::XML(xml_response)
            
          xml_doc.xpath("configConfMos/outConfigs/pair/fcpoolInitiators").each do |wwnn|
            puts ''
            puts "WWNN pool : #{ui.color("#{wwnn.attributes['name']}", :blue)}" + 
                  " status: #{ui.color("#{wwnn.attributes['status']}", :green)}"
          end
          
          
          xml_doc.xpath("configConfMos").each do |wwnn|
             puts "#{wwnn.attributes['errorCode']} #{ui.color("#{wwnn.attributes['errorDescr']}", :red)}"
          end


        when 'wwpn'
          json =  { :wwpn_name => Chef::Config[:knife][:name],  :wwpn_from => Chef::Config[:knife][:start], 
                    :wwpn_to => Chef::Config[:knife][:end],     :org => Chef::Config[:knife][:org] }.to_json
        
          xml_response = provisioner.set_wwpn_pool(json)
          xml_doc = Nokogiri::XML(xml_response)
          
          xml_doc.xpath("configConfMos/outConfigs/pair/fcpoolInitiators").each do |wwpn|
            puts ''
            puts "WWPN pool : #{ui.color("#{wwpn.attributes['name']}", :blue)}" + 
                  " status: #{ui.color("#{wwpn.attributes['status']}", :green)}"
          end
        
          
          xml_doc.xpath("configConfMos").each do |wwpn|
             puts "#{wwpn.attributes['errorCode']} #{ui.color("#{wwpn.attributes['errorDescr']}", :red)}"
          end
        
        when 'uuid'
          json =  { :uuid_pool_name => Chef::Config[:knife][:name], :uuid_from => Chef::Config[:knife][:start], 
                    :uuid_to => Chef::Config[:knife][:end],         :org => Chef::Config[:knife][:org] }.to_json
        
          xml_response = provisioner.set_uuid_pool(json)
          xml_doc = Nokogiri::XML(xml_response)
          
          xml_doc.xpath("configConfMos/outConfigs/pair/uuidpoolPool").each do |uuid|
            puts ''
            puts "UUID pool : #{ui.color("#{uuid.attributes['name']}", :blue)}" + 
                  " status: #{ui.color("#{uuid.attributes['status']}", :green)}"
          end
        
          
          xml_doc.xpath("configConfMos").each do |uuid|
             puts "#{uuid.attributes['errorCode']} #{ui.color("#{uuid.attributes['errorDescr']}", :red)}"
          end


        else
          puts "Incorrect options. Please make sure you are using one of the following: mac,uuid,wwpn,wwnn,managementip"
        end

      end

    end
  end
end

