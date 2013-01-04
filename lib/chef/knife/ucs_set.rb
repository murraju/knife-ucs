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
    class UcsSet < Knife

      include Knife::UCSBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ucs set (options)"

      option :config,
        :long => "--config-item CONFIGIETM",
        :description => "The item to configure which includes syslog, ntp, timezone, power, chassis-discovery, local-disk-policy",
        :proc => Proc.new { |f| Chef::Config[:knife][:config] = f }

      option :power,
        :long => "--power-policy POLICY",
        :description => "The power policy to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:policy] = f }
        
      option :discovery,
        :long => "--chassis-discovery POLICY",
        :description => "The chassis discovery policy",
        :proc => Proc.new { |f| Chef::Config[:knife][:discovery] = f }

      option :ntp,
        :long => "--ntp-server NTPSERVER",
        :description => "The ntp server to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:ntp] = f }

      option :timezone,
        :long => "--time-zone TIMEZONE",
        :description => "The timezone for this UCS Domain",
        :proc => Proc.new { |f| Chef::Config[:knife][:timezone] = f }

      option :localdiskpolicy,
        :long => "--local-disk-policy POLICY",
        :description => "The local disk policy to use: no-local-storage,any-configuration,no-raid,raid-1",
        :proc => Proc.new { |f| Chef::Config[:knife][:localdiskpolicy] = f }


      option :org,
        :long => "--org ORG",
        :description => "The organization to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:org] = f }
 
       option :syslogserver,
        :long => "--syslog-server SYSLOGSERVER",
        :description => "The syslog server to use <hostname or IP>",
        :proc => Proc.new { |f| Chef::Config[:knife][:syslogserver] = f }

       option :syslogfacility,
        :long => "--syslog-facility SYSLOGFACILITY",
        :description => "The syslog facility to use <local0-local7>",
        :proc => Proc.new { |f| Chef::Config[:knife][:syslogfacility] = f }

       option :syslogseverity,
        :long => "--syslog-severity SYSLOGSEVERITY",
        :description => "The syslog severity level to use <debugging,emergencies,information,alerts,warnings,errors,critical>",
        :proc => Proc.new { |f| Chef::Config[:knife][:syslogseverity] = f }

      def run
        $stdout.sync = true
        
        config_item = "#{Chef::Config[:knife][:config]}".downcase
        case config_item
        when 'syslog'
          json = { :syslog_server => Chef::Config[:knife][:syslogserver],
                   :facility => Chef::Config[:knife][:syslogfacility],
                   :severity => Chef::Config[:knife][:syslogseverity] }.to_json
          
          xml_response = provisioner.set_syslog_server(json)
          xml_doc = Nokogiri::XML(xml_response)
  
          xml_doc.xpath("configConfMos/outConfigs/pair/commSyslogClient").each do |syslog|
            puts ''
            puts "Syslog Server: #{ui.color("#{syslog.attributes['hostname']}", :blue)} status: #{ui.color("#{syslog.attributes['status']}", :green)}"
          end

          
          xml_doc.xpath("configConfMos").each do |syslog|
             puts "#{syslog.attributes['errorCode']} #{ui.color("#{syslog.attributes['errorDescr']}", :red)}"
          end

        when 'ntp'
          json = { :ntp_server => Chef::Config[:knife][:ntp] }.to_json
          
          xml_response = provisioner.set_ntp(json)
          xml_doc = Nokogiri::XML(xml_response)
  
          xml_doc.xpath("configConfMos/outConfigs/pair/commNtpProvider").each do |ntp|
            puts ''
            puts "NTP Server: #{ui.color("#{ntp.attributes['name']}", :blue)} status: #{ui.color("#{ntp.attributes['status']}", :green)}"
          end

          
          xml_doc.xpath("configConfMos").each do |ntp|
             puts "#{ntp.attributes['errorCode']} #{ui.color("#{ntp.attributes['errorDescr']}", :red)}"
          end
          
        when 'power'
          json = { :power_policy => Chef::Config[:knife][:policy] }.to_json
          
          xml_response = provisioner.set_power_policy(json)
          xml_doc = Nokogiri::XML(xml_response)
            
          xml_doc.xpath("configConfMos/outConfigs/pair/computePsuPolicy").each do |power|
            puts ''
            puts "Power Policy: #{ui.color("#{power.attributes['name']}", :blue)} status: #{ui.color("#{power.attributes['status']}", :green)}"
          end
          
          
          xml_doc.xpath("configConfMos").each do |power|
             puts "#{power.attributes['errorCode']} #{ui.color("#{power.attributes['errorDescr']}", :red)}"
          end          

        when 'chassis-discovery'
          json = { :chassis_discovery_policy => Chef::Config[:knife][:discovery] }.to_json
          
          xml_response = provisioner.set_chassis_discovery_policy(json)
          xml_doc = Nokogiri::XML(xml_response)
            
          xml_doc.xpath("configConfMos/outConfigs/pair/computeChassisDiscPolicy").each do |chassis|
            puts ''
            puts "Chassis Discovery Policy: #{ui.color("#{chassis.attributes['action']}", :blue)} status: #{ui.color("#{chassis.attributes['status']}", :green)}"
          end
          
          
          xml_doc.xpath("configConfMos").each do |chassis|
             puts "#{chassis.attributes['errorCode']} #{ui.color("#{chassis.attributes['errorDescr']}", :red)}"
          end

        when 'timezone'
          json = { :time_zone => Chef::Config[:knife][:timezone] }.to_json
          
          xml_response = provisioner.set_time_zone(json)
          xml_doc = Nokogiri::XML(xml_response)
            
          xml_doc.xpath("configConfMos/outConfigs/pair/commDateTime").each do |timezone|
            puts ''
            puts "Timezone: #{ui.color("#{timezone.attributes['timezone']}", :blue)} status: #{ui.color("#{timezone.attributes['status']}", :green)}"
          end
          
          
          xml_doc.xpath("configConfMos").each do |timezone|
             puts "#{timezone.attributes['errorCode']} #{ui.color("#{timezone.attributes['errorDescr']}", :red)}"
          end                    

        when 'local-disk-policy'
          json = { :local_disk_policy => Chef::Config[:knife][:localdiskpolicy], :org => Chef::Config[:knife][:org] }.to_json
          
          
          xml_response = provisioner.set_local_disk_policy(json)
          xml_doc = Nokogiri::XML(xml_response)
            
          xml_doc.xpath("configConfMos/outConfigs/pair/storageLocalDiskConfigPolicy").each do |localdiskpolicy|
            puts ''
            puts "Local Disk Policy: #{ui.color("#{localdiskpolicy.attributes['mode']}", :blue)} status: #{ui.color("#{localdiskpolicy.attributes['status']}", :green)}"
          end
          
          
          xml_doc.xpath("configConfMos").each do |localdiskpolicy|
             puts "#{localdiskpolicy.attributes['errorCode']} #{ui.color("#{localdiskpolicy.attributes['errorDescr']}", :red)}"
          end

           
        else
          puts ''
          puts "Incorrect options. Type --help to list options"
          puts ''
        end      
      end
    end
  end
end
