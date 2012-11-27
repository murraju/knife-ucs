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
    class UcsDatabagsCreate < Knife

      include Knife::UCSBase

      banner "knife ucs databags create"

      def run
      
       #Using Chef's UI (much better looking:)) instead of list methods provided by ucslib.
       
      macpool_list = [
         ui.color('Mac Address',    :bold),
         ui.color('Assigned To',    :bold),
         ui.color('vNIC',            :bold),
         ui.color('Assigned',       :bold)
       ]
       
      manager.xpath("configResolveClasses/outConfigs/macpoolPooled").each do |macpool|
         macpool_list << "#{macpool.attributes["id"]}"
         macpool_list << "#{macpool.attributes["assignedToDn"].to_s.scan(/ls-(\w+)/)}"
         macpool_list << "#{macpool.attributes["assignedToDn"].to_s.scan(/ether-vNIC-(\w+)/)}"
         macpool_list << begin
           state = "#{macpool.attributes["assigned"]}"
           case state
           when 'yes'
             ui.color(state, :green)
           when 'assigning'
             ui.color(state, :yellow)
           else
             ui.color(state, :red)
           end
         end
       end
       puts ui.list(macpool_list, :uneven_columns_across, 4)        
        
        
      end
    end
  end
end
