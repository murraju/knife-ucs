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
        :description => "The policy type <boot,host-firmware,mgmt-firmware>",
        :proc => Proc.new { |f| Chef::Config[:knife][:policy] = f }

      option :org,
        :long => "--org ORG",
        :description => "The organization to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:org] = f }
        
      option :config,
        :long => "--config CONFIG",
        :description => "The JSON config file to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:config] = f }



      def run
        $stdout.sync = true
        
        policy = "#{Chef::Config[:knife][:policy]}".downcase
        case policy
        when 'host-firmware'
        
          


          xml_response = provisioner.create_host_firmware_package(json)
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
