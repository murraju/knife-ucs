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
    class UcsTemplateCreate < Knife

      include Knife::UCSBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ucs template create (options)"

      option :template,
        :long => "--template-type TEMPLATE",
        :description => "The template type <vnic,vhba,serviceprofile>",
        :proc => Proc.new { |f| Chef::Config[:knife][:template] = f }

      option :name,
        :long => "--template-name TEMPLATENAME",
        :description => "The template name",
        :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }

      option :pool,
        :long => "--pool-name POOLNAME",
        :description => "The pool name to use for this template <macpool, wwnnpool, wwpnpool>",
        :proc => Proc.new { |f| Chef::Config[:knife][:pool] = f }

      option :fabric,
        :long => "--fabric FABRIC",
        :description => "Fabric: A or B switch",
        :proc => Proc.new { |f| Chef::Config[:knife][:fabric] = f }

      option :org,
        :long => "--org ORG",
        :description => "The organization to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:org] = f }

      option :vlans,
        :long => "--vlans VLANS",
        :description => "The vlans IDs to use separated by commas <vlan1,vlan2,vlan3>",
        :proc => Proc.new { |f| Chef::Config[:knife][:vlans] = f }

      option :vsan,
        :long => "--vsan-name VSAN",
        :description => "The vsan name to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:vsan] = f }

      option :native,
        :long => "--native-vlan VLAN",
        :description => "The native vlan name",
        :proc => Proc.new { |f| Chef::Config[:knife][:native] = f }

      option :mtu,
        :long => "--mtu MTU",
        :description => "The MTU value",
        :proc => Proc.new { |f| Chef::Config[:knife][:mtu] = f }
        
      def run
        $stdout.sync = true
        
        template_type = "#{Chef::Config[:knife][:template]}".downcase
        case template_type
        when 'vnic'
    		  
          json = { :vnic_template_name => Chef::Config[:knife][:name], :vnic_template_mac_pool => Chef::Config[:knife][:pool],
                   :switch => Chef::Config[:knife][:fabric], :org => Chef::Config[:knife][:org], :vnic_template_VLANs => Chef::Config[:knife][:vlans],
                   :vnic_template_native_VLAN => Chef::Config[:knife][:native], :vnic_template_mtu => Chef::Config[:knife][:mtu] }.to_json
          
          xml_response = provisioner.set_vnic_template(json)
          xml_doc = Nokogiri::XML(xml_response)

          xml_doc.xpath("configConfMos/outConfigs/pair/vnicLanConnTempl").each do |vnic|
              puts ''
              puts "vNIC Template: #{ui.color("#{vnic.attributes['name']}", :blue)} Type: #{ui.color("#{vnic.attributes['templType']}", :blue)}" + 
                    " Fabric: #{ui.color("#{vnic.attributes['switchId']}", :blue)} status: #{ui.color("#{vnic.attributes['status']}", :green)}"
          end        

          #Ugly...refactor later to parse error with better exception handling. Nokogiri xpath search for elements might be an option
          xml_doc.xpath("configConfMos").each do |vnic|
             puts "#{vnic.attributes['errorCode']} #{ui.color("#{vnic.attributes['errorDescr']}", :red)}"
          end          

        when 'vhba'
    		  
          json = { :vbha_template_name => Chef::Config[:knife][:name], :wwpn_pool => Chef::Config[:knife][:pool],
                   :switch => Chef::Config[:knife][:fabric], :vsan_name => Chef::Config[:knife][:vsan], :org => Chef::Config[:knife][:org] }.to_json       
               		
               		
          #puts provisioner.set_vhba_template(json)
          xml_response = provisioner.set_vhba_template(json)
          xml_doc = Nokogiri::XML(xml_response)
          
          xml_doc.xpath("configConfMos/outConfigs/pair/vnicSanConnTempl").each do |vnic|
              puts ''
              puts "vHBA Template: #{ui.color("#{vnic.attributes['name']}", :blue)} Type: #{ui.color("#{vnic.attributes['templType']}", :blue)}" + 
                    " Fabric: #{ui.color("#{vnic.attributes['switchId']}", :blue)} status: #{ui.color("#{vnic.attributes['status']}", :green)}"
          end        
          
          #Ugly...refactor later to parse error with better exception handling. Nokogiri xpath search for elements might be an option
          xml_doc.xpath("configConfMos").each do |vnic|
             puts "#{vnic.attributes['errorCode']} #{ui.color("#{vnic.attributes['errorDescr']}", :red)}"
          end

        when 'serviceprofile'
    		  
          json = { :service_profile_template_name => Chef::Config[:knife][:name], :service_profile_template_boot_policy => Chef::Config[:knife][:bootpolicy],
                   :service_profile_template_host_fw_policy => Chef::Config[:knife][:hostfwpolicy], :service_profile_template_mgmt_fw_policy => Chef::Config[:knife][:mgmtfwpolicy], 
                   :org => Chef::Config[:knife][:org] }.to_json       
                   # 
                   # service_profile_template_name               = JSON.parse(json)['service_profile_template_name']
                   # service_profile_template_boot_policy        = JSON.parse(json)['service_profile_template_boot_policy']
                   # service_profile_template_host_fw_policy     = JSON.parse(json)['service_profile_template_host_fw_policy']
                   # service_profile_template_mgmt_fw_policy     = JSON.parse(json)['service_profile_template_mgmt_fw_policy']
                   # service_profile_template_uuid_pool          = JSON.parse(json)['service_profile_template_uuid_pool']
                   # service_profile_template_vnics_a            = JSON.parse(json)['service_profile_template_vnics_a'].split(',')
                   # service_profile_template_vnic_a_template    = JSON.parse(json)['service_profile_template_vnic_a_template']
                   # service_profile_template_vnics_b            = JSON.parse(json)['service_profile_template_vnics_b'].split(',')
                   # service_profile_template_vnic_b_template    = JSON.parse(json)['service_profile_template_vnic_b_template'].to_s
                   # service_profile_template_wwnn_pool          = JSON.parse(json)['service_profile_template_wwnn_pool'].to_s
                   # service_profile_template_vhba_a             = JSON.parse(json)['service_profile_template_vhba_a']
                   # service_profile_template_vhba_a_template    = JSON.parse(json)['service_profile_template_vhba_a_template']
                   # service_profile_template_vhba_b             = JSON.parse(json)['service_profile_template_vhba_b'].to_s
                   # service_profile_template_vhba_b_template    = JSON.parse(json)['service_profile_template_vhba_b_template'].to_s
                   # org                                         = JSON.parse(json)['org'].to_s
                   #                    
               		
          #puts provisioner.set_vhba_template(json)
          xml_response = provisioner.set_vhba_template(json)
          xml_doc = Nokogiri::XML(xml_response)
          
          xml_doc.xpath("configConfMos/outConfigs/pair/vnicSanConnTempl").each do |vnic|
              puts ''
              puts "vHBA Template: #{ui.color("#{vnic.attributes['name']}", :blue)} Type: #{ui.color("#{vnic.attributes['templType']}", :blue)}" + 
                    " Fabric: #{ui.color("#{vnic.attributes['switchId']}", :blue)} status: #{ui.color("#{vnic.attributes['status']}", :green)}"
          end        
          
          #Ugly...refactor later to parse error with better exception handling. Nokogiri xpath search for elements might be an option
          xml_doc.xpath("configConfMos").each do |vnic|
             puts "#{vnic.attributes['errorCode']} #{ui.color("#{vnic.attributes['errorDescr']}", :red)}"
          end          
        else
          "Incorrect options. Please make sure you are using one of the following: vnic,vhba,serviceprofile"
        end
        
      end
    end
  end
end
