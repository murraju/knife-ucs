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
    class UcsVlanDelete < Knife

      include Knife::UCSBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ucs vlan delete (options)"

      option :vlanid,
        :long => "--vlan-id VLANID",
        :description => "The VLAN ID",
        :proc => Proc.new { |f| Chef::Config[:knife][:vlanid] = f }

      option :vlanname,
        :long => "--vlan-name VLANNAME",
        :description => "The VLAN NAME",
        :proc => Proc.new { |f| Chef::Config[:knife][:vlanname] = f }

      def run
        $stdout.sync = true
        
        json = {:vlan_id => Chef::Config[:knife][:vlanid], :vlan_name => Chef::Config[:knife][:vlanname] }.to_json
        
        xml_response = destroyer.delete_vlan(json)
        xml_doc = Nokogiri::XML(xml_response)
        
        xml_doc.xpath("configConfMos/outConfigs/pair/fabricVlan").each do |org|
            puts ''
            puts "VLAN ID: #{ui.color("#{org.attributes['id']}", :blue)} NAME: #{ui.color("#{org.attributes['name']}", :blue)}" + 
                  " status: #{ui.color("#{org.attributes['status']}", :red)}"
        end        
        
        xml_doc.xpath("configConfMos").each do |org|
           puts "#{org.attributes['errorCode']} #{ui.color("#{org.attributes['errorDescr']}", :red)}"
        end        
        
      end
    end
  end
end
