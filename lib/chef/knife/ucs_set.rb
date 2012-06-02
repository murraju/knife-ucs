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
    class UcsSet < Knife

      include Knife::UCSBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ucs set (options)"

      attr_accessor :initial_sleep_delay

      option :config,
        :long => "--config-item CONFIGIETM",
        :description => "The item to configure which includes ntp, time-zone, power-policy, chassis-discovery-policy",
        :proc => Proc.new { |f| Chef::Config[:knife][:config] = f }

      option :power,
        :long => "--power-policy POWERPOLICY",
        :description => "The power policy to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:policy] = f }

      option :ntp,
        :long => "--ntp-server NTPSERVER",
        :description => "The ntp server to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:ntp] = f }

      option :timezone,
        :long => "--time-zone TIMEZONE",
        :description => "The timezone for this UCS Domain",
        :proc => Proc.new { |f| Chef::Config[:knife][:timezone] = f }


      def run
        $stdout.sync = true
        
        config_item = "#{Chef::Config[:knife][:config]}"
        case config_item
        when 'ntp'
          json = { :ntp_server => Chef::Config[:knife][:ntp] }.to_json
          
          puts provisioner.set_ntp(json)
          
        else
          puts "Incorrect options. Please make sure you are using one of the following: ntp,time-zone,power-policy,chassis-discovery-policy"
        end      
        
      end
    end
  end
end
