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
    class UcsServiceprofilesList < Knife

      include Knife::UCSBase

      banner "knife ucs serviceprofiles list"

      def run
      
       #Using Chef's UI (much better looking:)) instead of list methods provided by ucslib.
       
       serviceprofile_list = [
         ui.color('Name',           :bold),
         ui.color('Path',           :bold),
         ui.color('UUID',           :bold),
         ui.color('BootPolicy',     :bold),
         ui.color('State',          :bold),
         ui.color('Association',    :bold)
       ]
       
       inventory.xpath("configResolveClasses/outConfigs/lsServer").each do |serviceprofile|
         serviceprofile_list << "#{serviceprofile.attributes["name"]}"
         serviceprofile_list << "#{serviceprofile.attributes["dn"]}"
         serviceprofile_list << "#{serviceprofile.attributes["uuid"]}"
         serviceprofile_list << "#{serviceprofile.attributes["operBootPolicyName"]}"
         serviceprofile_list << "#{serviceprofile.attributes["operState"]}"
         serviceprofile_list << begin
           state = "#{serviceprofile.attributes["assocState"]}"
           case state
           when 'associated'
             ui.color(state, :green)
           when 'associating'
             ui.color(state, :yellow)
           else
             ui.color(state, :red)
           end
         end
       end
       puts ui.list(serviceprofile_list, :uneven_columns_across, 6)        
        
        
      end
    end
  end
end
