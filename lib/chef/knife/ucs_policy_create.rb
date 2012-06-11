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
    class UcsPolicyCreate < Knife

      include Knife::UCSBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ucs policy create (options)"

      attr_accessor :initial_sleep_delay

      option :policy,
        :long => "--policy-type POLICY",
        :description => "The policy type <boot,hostfirmware,managementfirmware>",
        :proc => Proc.new { |f| Chef::Config[:knife][:policy] = f }

      option :name,
        :long => "--policy-name POLICYNAME",
        :description => "The policy name",
        :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }

      option :config,
        :long => "--config CONFIG",
        :description => "The JSON config file to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:config] = f }

      option :org,
        :long => "--org ORG",
        :description => "The organization to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }

      option :hardwaremodel,
        :long => "--hardware-model MODEL",
        :description => "The hardware model",
        :proc => Proc.new { |f| Chef::Config[:knife][:hardwaremodel] = f }

      option :hardwaretype,
        :long => "--hardware-type TYPE",
        :description => "The hardware type",
        :proc => Proc.new { |f| Chef::Config[:knife][:hardwaretype] = f }

      option :hardwarevendor,
        :long => "--hardware-vendor VENDOR",
        :description => "The hardware vendor",
        :proc => Proc.new { |f| Chef::Config[:knife][:hardwarevendor] = f }

      option :firmwareversion,
        :long => "--firmware-version VERSION",
        :description => "The firmware version",
        :proc => Proc.new { |f| Chef::Config[:knife][:firmwareversion] = f }

      def run
        $stdout.sync = true
        
        policy = "#{Chef::Config[:knife][:policy]}".downcase
        case policy
        when 'host-firmware'
          json = {  :host_firmware_pkg_name => Chef::Config[:knife][:name],       :hardware_model => Chef::Config[:knife][:hardwaremodel],
                    :hardware_type => Chef::Config[:knife][:hardwaretype],        :hardware_vendor => Chef::Config[:knife][:hardware_vendor],
                    :firmware_version => Chef::Config[:knife][:firmwareversion],   :org => Chef::Config[:knife][:org]  }.to_json
                    
          puts provisioner.create_host_firmware_package(json)          

          # xml_response = provisioner.create_host_firmware_package(json)
          # xml_doc = Nokogiri::XML(xml_response)
          # 
          # xml_doc.xpath("configConfMos/outConfigs/pair/ippoolBlock").each do |ippool|
          #   puts ''
          #   puts "Management IP Block from: #{ui.color("#{ippool.attributes['from']}", :blue)} to: #{ui.color("#{ippool.attributes['to']}", :blue)}" + 
          #         " status: #{ui.color("#{ippool.attributes['status']}", :green)}"
          # end
          # 
          # #Ugly...refactor later to parse error with better exception handling. Nokogiri xpath search for elements might be an option
          # xml_doc.xpath("configConfMos").each do |ippool|
          #    puts "#{ippool.attributes['errorCode']} #{ui.color("#{ippool.attributes['errorDescr']}", :red)}"
          # end
          
        else
          puts "Incorrect options. Please make sure you are using one of the following: "
        end     
        
      end
      
    end
  end
end
