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

      def run
        attr_accessor :initial_sleep_delay

        option :pool,
          :short => "-P POOL",
          :long => "--pool POOLTYPE",
          :description => "UCS pool types <mac,uuid,wwpn,wwnn,managementip>",
          :proc => Proc.new { |f| Chef::Config[:knife][:pool] = f }

        option :name,
          :long => "--poolname POOLNAME",
          :description => "The pool name",
          :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }

        option :start,
          :long => "--poolstart STARTRANGE",
          :description => "Start of a pool range <IP, WWPN, WWNN, MAC>",
          :proc => Proc.new { |f| Chef::Config[:knife][:start] = f }

        option :end,
          :long => "--poolend ENDRANGE",
          :description => "End of a pool range <IP, WWPN, WWNN, MAC>",
          :proc => Proc.new { |f| Chef::Config[:knife][:end] = f }


        option :mask,
          :long => "--subnetmask SUBNETMASK",
          :description => "The subnet mask for an IP range",
          :proc => Proc.new { |f| Chef::Config[:knife][:mask] = f }

        option :gateway,
          :long => "--gateway IPGATEWAY",
          :description => "The IP Gateway address of a subnet",
          :proc => Proc.new { |f| Chef::Config[:knife][:gateway] = f }
          
        pool_type = "#{Chef::Config[:knife][:pool]}"
        case pool_type
        when 'managementip'
          json = { :start_ip => Chef::Config[:knife][:start],  }
        end

      end

    end
  end
end

