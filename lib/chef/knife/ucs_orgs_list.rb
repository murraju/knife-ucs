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
    class UcsOrgsList < Knife

      include Knife::UCSBase

      banner "knife ucs orgs list"

      def run
        $stdout.sync = true
        
        #Using Chef's UI (much better looking:)) instead of list methods provided by ucslib.
        
        orgs_list = [
          ui.color('Path',    :bold),
          ui.color('Level',   :bold),
          ui.color('Name',    :bold)
        ]
        
        inventory.xpath("configResolveClasses/outConfigs/orgOrg").each do |org|
          orgs_list << "#{org.attributes["dn"]}"
          orgs_list << "#{org.attributes["level"]}"
          orgs_list << "#{org.attributes["name"]}"
        end        
        puts ui.list(orgs_list, :uneven_columns_across, 3)
        
      end
    end
  end
end
