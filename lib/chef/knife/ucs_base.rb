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

require 'chef/knife'
require 'ucslib'

class Chef
  class Knife
    module UCSBase

      def self.included(includer)
        includer.class_eval do

          deps do
            require 'readline'
            require 'chef/json_compat'
          end

          option :ucsm_username,
            :short => "-U USERNAME",
            :long => "--cisco-ucsm-username USERNAME",
            :description => "Your Cisco UCS Manager Username",
            :proc => Proc.new { |key| Chef::Config[:knife][:ucsm_username] = key }

          option :ucsm_password,
            :short => "-P PASSWORD",
            :long => "--cisco-ucsm-password PASSWORD",
            :description => "Your Cisco UCS Manager password",
            :proc => Proc.new { |key| Chef::Config[:knife][:ucsm_password] = key }

          option :ucsm_host,
            :short => "-H HOST",
            :long => "--cisco-ucsm-host HOST",
            :description => "Your Cisco UCS Manager FI name or IP address",
            :proc => Proc.new { |endpoint| Chef::Config[:knife][:ucsm_host] = endpoint }

          
        end
      end

      def connection
        ucs_session = UCSToken.new
        Chef::Log.debug("username: #{Chef::Config[:knife][:ucsm_username]}")
        Chef::Log.debug("password: #{Chef::Config[:knife][:ucsm_password]}")
        Chef::Log.debug("host:     #{Chef::Config[:knife][:ucsm_host]}")
        @connection ||= begin
          connection = ucs_session.get_token({
            :username => Chef::Config[:knife][:ucsm_username],
            :password => Chef::Config[:knife][:ucsm_password],
            :ip       => Chef::Config[:knife][:ucsm_host]
          }.to_json)
        end
      end
      
      #Intialize objects
      def inventory
        ucs_inventory = UCSInventory.new
        @inventory ||= begin
          inventory = ucs_inventory.discover(connection)
        end
      end
      
      def provisioner
        @provisioner ||= begin
          provisioner = UCSProvision.new(connection)
        end 
      end

      def manager
        ucs_manager = UCSManage.new(connection)
        @manager ||= begin
          manager = ucs_manager.discover_state
        end 
      end
      
      def destroyer
        @destroyer ||= begin
          destroyer = UCSDestroy.new(connection)
        end 
      end
      
      def locate_config_value(key)
        key = key.to_sym
        Chef::Config[:knife][key] || config[key]
      end

      def msg_pair(label, value, color=:cyan)
        if value && !value.to_s.empty?
          puts "#{ui.color(label, color)}: #{value}"
        end
      end

    end
  end
end


