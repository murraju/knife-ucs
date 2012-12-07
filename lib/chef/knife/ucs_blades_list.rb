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
    class UcsBladesList < Knife

      include Knife::UCSBase

      banner "knife ucs blades list"

      def run
        $stdout.sync = true

        
        #Using Chef's UI (much better looking:)) instead of list methods provided by ucslib.
        
        blades_list = [
          ui.color('ID',            :bold),
          ui.color('Model',         :bold),
          ui.color('Serial',        :bold),
          ui.color('CPUs',          :bold),
          ui.color('Memory[MB]',    :bold),
          ui.color('Adaptors',      :bold),
          ui.color('EtnernetIfs',   :bold),
          ui.color('FCifs',         :bold),
          ui.color('Availability',  :bold),
          ui.color('Power',         :bold)
        ]
        
        inventory.xpath("configResolveClasses/outConfigs/computeBlade").each do |blade|
          blades_list << "#{blade.attributes["serverId"]}"
          blades_list << "#{blade.attributes["model"]}"
          blades_list << "#{blade.attributes["serial"]}"
          blades_list << "#{blade.attributes["numOfCpus"]}"
          blades_list << "#{blade.attributes["availableMemory"]}"
          blades_list << "#{blade.attributes["numOfAdaptors"]}"
          blades_list << "#{blade.attributes["numOfEthHostIfs"]}"
          blades_list << "#{blade.attributes["numOfFcHostIfs"]}"
          blades_list << "#{blade.attributes["availability"]}"
          blades_list << begin
            power = "#{blade.attributes["operPower"]}"
            case power
            when 'off'
              ui.color(power, :red)
            when 'pending'
              ui.color(power, :yellow)
            else
              ui.color(power, :green)
            end
          end
        end
        puts ui.list(blades_list, :uneven_columns_across, 10)
        
      end
    end
  end
end


