# Author:: Murali Raju (<murali.raju@appliv.com>)
# Copyright:: Copyright (c) 2012 Murali Raju.
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

      banner "knife ucs pool create (options)"
      
      attr_accessor :initial_sleep_delay
      
      option :pool,
        :short => "-P POOL",
        :long => "--pool POOLTYPE",
        :description => "UCS pool types <mac,uuid,wwpn,wwnn,managementip>",
        :proc => Proc.new { |f| Chef::Config[:knife][:pool] = f }

      option :name,
        :short => "-N NAME",
        :long => "--pool-name POOLNAME",
        :description => "The pool name",
        :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }

      option :start,
        :short => "-S START",
        :long => "--pool-start STARTRANGE",
        :description => "Start of a pool range <IP, WWPN, WWNN, MAC>",
        :proc => Proc.new { |f| Chef::Config[:knife][:start] = f }

      option :end,
        :short => "-E END",
        :long => "--pool-end ENDRANGE",
        :description => "End of a pool range <IP, WWPN, WWNN, MAC>",
        :proc => Proc.new { |f| Chef::Config[:knife][:end] = f }


      option :mask,
        :short => "-M MASK",
        :long => "--subnet-mask SUBNETMASK",
        :description => "The subnet mask for an IP range",
        :proc => Proc.new { |f| Chef::Config[:knife][:mask] = f }

      option :gateway,
        :short => "-G GATEWAY",
        :long => "--gateway IPGATEWAY",
        :description => "The IP Gateway address of a subnet",
        :proc => Proc.new { |f| Chef::Config[:knife][:gateway] = f }

      option :org,
        :short => "-O ORG",
        :long => "--org ORG",
        :description => "The organization",
        :proc => Proc.new { |f| Chef::Config[:knife][:org] = f }      

      def run
        $stdout.sync = true
          
        pool_type = "#{Chef::Config[:knife][:pool]}"
        case pool_type
        when 'managementip'
          json = { :start_ip => Chef::Config[:knife][:start],   :end_ip => Chef::Config[:knife][:end],
                   :subnet_mask => Chef::Config[:knife][:mask], :gateway => Chef::Config[:knife][:gateway] }.to_json
          
          xml_response = provisioner.create_management_ip_pool(json)
          xml_doc = Nokogiri::XML(xml_response)
  
          xml_doc.xpath("configConfMos/outConfigs/pair/ippoolBlock").each do |ippool|
            puts ''
            puts "Management IP Block from: #{ui.color("#{ippool.attributes['from']}", :magenta)} to: #{ui.color("#{ippool.attributes['to']}", :magenta)}" + 
                  " status: #{ui.color("#{ippool.attributes['status']}", :green)}"
          end

          #Ugly...refactor later to parse error with better exception handling. Nokogiri xpath search for elements might be an option
          xml_doc.xpath("configConfMos").each do |ippool|
             puts "#{ippool.attributes['errorCode']} #{ui.color("#{ippool.attributes['errorDescr']}", :red)}"
          end
          
        when 'mac'
          json =  { :mac_pool_name => Chef::Config[:knife][:name],  :mac_pool_start => Chef::Config[:knife][:start], 
                    :mac_pool_end => Chef::Config[:knife][:end],    :org => Chef::Config[:knife][:org] }.to_json
          
          xml_response = provisioner.create_mac_pool(json)
          xml_doc = Nokogiri::XML(xml_response)
  
          xml_doc.xpath("configConfMos/outConfigs/pair/macpoolPool").each do |macpool|
            puts ''
            puts "MAC address pool : #{ui.color("#{macpool.attributes['name']}", :magenta)}" + 
                  " status: #{ui.color("#{macpool.attributes['status']}", :green)}"
          end

          #Ugly...refactor later to parse error with better exception handling. Nokogiri xpath search for elements might be an option
          xml_doc.xpath("configConfMos").each do |macpool|
             puts "#{macpool.attributes['errorCode']} #{ui.color("#{macpool.attributes['errorDescr']}", :red)}"
          end          

        else
          puts "Incorrect options. Please make sure you are using one of the following: mac,uuid,wwpn,wwnn,managementip"
        end

      end

    end
  end
end

