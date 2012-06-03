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
    class UcsTemplateCreate < Knife

      include Knife::UCSBase

      deps do
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ucs template create (options)"

      attr_accessor :initial_sleep_delay

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
        :description => "The pool name for this template <macpool, wwnnpool, wwpnpool>",
        :proc => Proc.new { |f| Chef::Config[:knife][:pool] = f }

      option :fabric,
        :long => "--fabric FABRIC",
        :description => "The fabric: A or B",
        :proc => Proc.new { |f| Chef::Config[:knife][:fabric] = f }

      option :org,
        :long => "--org ORG",
        :description => "The organization to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:org] = f }

      option :vlans,
        :long => "--vlans VLANS",
        :description => "The vlans to use separated by commas <vlan1,vlan2,vlan3>",
        :proc => Proc.new { |f| Chef::Config[:knife][:vlans] = f }

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
        
        template_type = "#{Chef::Config[:knife][:template]}"
        case template_type
        when 'vnic'
    		  
          json = { :vnic_template_name => Chef::Config[:knife][:name], :vnic_template_mac_pool => Chef::Config[:knife][:pool],
                   :switch => Chef::Config[:knife][:fabric], :org => Chef::Config[:knife][:org], :vnic_template_VLANs => Chef::Config[:knife][:vlans],
                   :vnic_template_native_VLAN => Chef::Config[:knife][:native], :vnic_template_mtu => Chef::Config[:knife][:mtu] }.to_json
          
          puts provisioner.create_vnic_template(json)
          
        end
        
      end
    end
  end
end
