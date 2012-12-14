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
    class UcsServiceprofilesList < Knife

      include Knife::UCSBase

      banner "knife ucs serviceprofiles list"

      def run
      
       #Using Chef's UI (much better looking:)) instead of list methods provided by ucslib.
       
       serviceprofile_list = [
         ui.color('Name',           :bold),
         ui.color('Organization',   :bold),
         ui.color('UUID',           :bold),
         ui.color('BootPolicy',     :bold),
         ui.color('State',          :bold),
         ui.color('Association',    :bold)
       ]
       
       inventory.xpath("configResolveClasses/outConfigs/lsServer").each do |serviceprofile|
        extracted_org_names = "#{serviceprofile.attributes["dn"]}"
        org_names = extracted_org_names.to_s.scan(/\/(org-\w+)/)
        org_names.each do |orgs| #Ugly...refactor
          orgs.each do |org|
            @org = org
          end
        end
        serviceprofile_list << "#{serviceprofile.attributes["name"]}"
        serviceprofile_list << "#{@org}"
        serviceprofile_list << "#{serviceprofile.attributes["uuid"]}"
        extracted_boot_policy_names = "#{serviceprofile.attributes["operBootPolicyName"]}"
        boot_policy_names = extracted_boot_policy_names.to_s.scan(/\/(boot-policy-\w+)/)
        boot_policy_names.each do |boot_policies| #Ugly...refactor
          boot_policies.each do |boot_policy|
            @boot_policy = boot_policy
          end
        end 
        serviceprofile_list << "#{@boot_policy}"
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
