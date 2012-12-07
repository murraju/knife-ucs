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
    class UcsCpusList < Knife

      include Knife::UCSBase

      banner "knife ucs cpus list"

      def run
        $stdout.sync = true
        
        #Using Chef's UI (much better looking:)) instead of list methods provided by ucslib.
        
        cpus_list = [
          ui.color('ID',            :bold),
          ui.color('Model',         :bold),
          ui.color('Architecture',  :bold),
          ui.color('Cores',         :bold),
          ui.color('EnabledCores',  :bold),
          ui.color('Speed',         :bold),
          ui.color('Threads',       :bold),
          ui.color('Vendor',        :bold)
        ]
        
        inventory.xpath("configResolveClasses/outConfigs/processorUnit").each do |processorunit|
          cpus_list << "#{processorunit.attributes["id"]}"
          cpus_list << "#{processorunit.attributes["model"]}"
          cpus_list << "#{processorunit.attributes["arch"]}"
          cpus_list << "#{processorunit.attributes["cores"]}"
          cpus_list << "#{processorunit.attributes["coresEnabled"]}"
          cpus_list << "#{processorunit.attributes["speed"]}"
          cpus_list << "#{processorunit.attributes["threads"]}"
          cpus_list << "#{processorunit.attributes["vendor"]}"
        end        
        puts ui.list(cpus_list, :uneven_columns_across, 8)
        
      end
    end
  end
end
