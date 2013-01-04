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
    class UcsPolicyUpdate < Knife

      include Knife::UCSBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ucs policy update (options)"


      option :policy,
        :long => "--policy-type POLICY",
        :description => "The policy type <boot,host-firmware,mgmt-firmware>",
        :proc => Proc.new { |f| Chef::Config[:knife][:policy] = f }

      option :org,
        :long => "--org ORG",
        :description => "The organization to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:org] = f }

      option :name,
        :long => "--policy-name POLICYNAME",
        :description => "The policy name to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }

      option :hardwaremodel,
        :long => "--hardware-model MODEL",
        :description => "The hardware model used with firmware policies",
        :proc => Proc.new { |f| Chef::Config[:knife][:hardwaremodel] = f }

      option :hardwaretype,
        :long => "--hardware-type TYPE",
        :description => "The hardware type used with firmware policies",
        :proc => Proc.new { |f| Chef::Config[:knife][:hardwaretype] = f }

      option :hardwarevendor,
        :long => "--hardware-vendor VENDOR",
        :description => "The hardware vendor used with firmware policies",
        :proc => Proc.new { |f| Chef::Config[:knife][:hardwarevendor] = f }

      option :firmwareversion,
        :long => "--firmware-version VERSION",
        :description => "The firmware version used with firmware policies",
        :proc => Proc.new { |f| Chef::Config[:knife][:firmwareversion] = f }


      def run
        $stdout.sync = true
        
        policy = "#{Chef::Config[:knife][:policy]}".downcase
        case policy
        when 'host-firmware'
        
          json = { :host_firmware_pkg_name => Chef::Config[:knife][:name], :hardware_model => Chef::Config[:knife][:hardwaremodel].to_s,
                   :hardware_type => Chef::Config[:knife][:hardwaretype].to_s,  :hardware_vendor => Chef::Config[:knife][:hardwarevendor].to_s, 
                   :firmware_version => Chef::Config[:knife][:firmwareversion].to_s, :org => Chef::Config[:knife][:org] }.to_json
          

          xml_response = updater.update_host_firmware_package(json)
          xml_doc = Nokogiri::XML(xml_response)
          
          xml_doc.xpath("configConfMos/outConfigs/pair/firmwareComputeHostPack").each do |hostfw|
            puts ''
            puts "Host Firmware Pack: #{ui.color("#{hostfw.attributes['name']}", :blue)}" + 
                  " status: #{ui.color("#{hostfw.attributes['status']}", :green)}"
          end
          
          xml_doc.xpath("configConfMos").each do |hostfw|
             puts "#{hostfw.attributes['errorCode']} #{ui.color("#{hostfw.attributes['errorDescr']}", :red)}"
          end
          
        else
          puts "Incorrect options. Please make sure you are using one of the following: host-firmware, mgmt-firmware"
        end     
        
      end
      
    end
  end
end
