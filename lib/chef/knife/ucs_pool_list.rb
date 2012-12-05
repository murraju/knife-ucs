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
    class UcsPoolList < Knife

      include Knife::UCSBase

      banner "knife ucs pool list"

      def run
      
       #Using Chef's UI (much better looking:)) instead of list methods provided by ucslib.
       
      macpool_list = [
         ui.color('Mac Address',    :bold),
         ui.color('Assigned To',    :bold),
         ui.color('vNIC',           :bold),
         ui.color('Assigned',       :bold)
       ]
       
      manager.xpath("configResolveClasses/outConfigs/macpoolPooled").each do |macpool|
         macpool_list << "#{macpool.attributes["id"]}"
         extracted_service_profile_names = "#{macpool.attributes["assignedToDn"]}"
         service_profile_names = extracted_service_profile_names.to_s.scan(/ls-(\w+)/)
         service_profile_names.each do |service_profile_name|
          hostnames = service_profile_name
          hostnames.each do |host_name|
            @host = host_name
          end
         end
         vnics = extracted_service_profile_names.to_s.scan(/ether-vNIC-(\w+)/)
         vnics.each do |vnic|
          assgined_vnics = vnic
          assgined_vnics.each do |vnic|
            @vnic = vnic
          end
         end
         macpool_list << "#{@host}"
         macpool_list << "#{@vnic}"
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
