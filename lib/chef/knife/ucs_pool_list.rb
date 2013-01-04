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

      banner "knife ucs pool list (options)"

      option :type,
        :long => "--pool-type POOLTYPE",
        :description => "The policy type <mac,uuid,wwpn,wwnn>",
        :proc => Proc.new { |f| Chef::Config[:knife][:type] = f }

      option :org,
        :long => "--org ORG",
        :description => "The organization to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:org] = f }

      option :name,
        :long => "--policy-name POLICYNAME",
        :description => "The policy name to use",
        :proc => Proc.new { |f| Chef::Config[:knife][:name] = f }


      def run
        $stdout.sync = true
      
        #Using Chef's UI (much better looking:)) instead of list methods provided by ucslib.
        pool_type = "#{Chef::Config[:knife][:type]}".downcase
        case pool_type
        when 'wwpn'
          wwpnpool_list = [
            ui.color('Organization', :bold),
            ui.color('WWPN',         :bold),
            ui.color('Assigned To',  :bold),
            ui.color('Assigned',     :bold)
          ]
          manager.xpath("configResolveClasses/outConfigs/fcpoolInitiator").each do |wwpnpool|
            extracted_org_names = "#{wwpnpool.attributes["assignedToDn"]}"
            org_names = extracted_org_names.to_s.scan(/\/(org-\w+)/)
            org_names.each do |orgs| #Ugly...refactor
              orgs.each do |org|
                @org = org
              end
            end
            wwpnpool_list << "#{@org}"
            wwpnpool_list << "#{wwpnpool.attributes["id"]}"
            extracted_service_profile_names = "#{wwpnpool.attributes["assignedToDn"]}"
            service_profile_names = extracted_service_profile_names.to_s.scan(/ls-(\w+)/)
            service_profile_names.each do |service_profile_name| #Ugly...refactor
            hostnames = service_profile_name
            hostnames.each do |host_name|
                  @host = host_name
                end
            end
            wwpnpool_list << "#{@host}"
            wwpnpool_list << begin
              state = "#{wwpnpool.attributes["assigned"]}"
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
          puts ui.list(wwpnpool_list, :uneven_columns_across, 4)

        when 'uuid'
          uuidpool_list = [
            ui.color('Organization', :bold),
            ui.color('UUID Suffix',  :bold),
            ui.color('Assigned To',  :bold),
            ui.color('Assigned',     :bold)
          ]
          manager.xpath("configResolveClasses/outConfigs/uuidpoolPooled").each do |uuidpool|
            extracted_org_names = "#{uuidpool.attributes["assignedToDn"]}"
            org_names = extracted_org_names.to_s.scan(/\/(org-\w+)/)
            org_names.each do |orgs| #Ugly...refactor
              orgs.each do |org|
                @org = org
              end
            end
            uuidpool_list << "#{@org}"
            uuidpool_list << "#{uuidpool.attributes["id"]}"
            extracted_service_profile_names = "#{uuidpool.attributes["assignedToDn"]}"
            service_profile_names = extracted_service_profile_names.to_s.scan(/ls-(\w+)/)
            service_profile_names.each do |service_profile_name| #Ugly...refactor
            hostnames = service_profile_name
            hostnames.each do |host_name|
                  @host = host_name
                end
            end
            uuidpool_list << "#{@host}"
            uuidpool_list << begin
              state = "#{uuidpool.attributes["assigned"]}"
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
          puts ui.list(uuidpool_list, :uneven_columns_across, 4)

        when 'mac' 
          macpool_list = [
             ui.color('Organization',   :bold),
             ui.color('Mac Address',    :bold),
             ui.color('Assigned To',    :bold),
             ui.color('vNIC',           :bold),
             ui.color('Assigned',       :bold)
           ]
           
          manager.xpath("configResolveClasses/outConfigs/macpoolPooled").each do |macpool|
            extracted_org_names = "#{macpool.attributes["assignedToDn"]}"
            org_names = extracted_org_names.to_s.scan(/\/(org-\w+)/)
            org_names.each do |orgs| #Ugly...refactor
              orgs.each do |org|
                @org = org
              end
            end
            macpool_list << "#{@org}"
            macpool_list << "#{macpool.attributes["id"]}"
            extracted_service_profile_names = "#{macpool.attributes["assignedToDn"]}"
            service_profile_names = extracted_service_profile_names.to_s.scan(/ls-(\w+)/)
            service_profile_names.each do |service_profile_name| #Ugly...refactor
            hostnames = service_profile_name
            hostnames.each do |host_name|
                  @host = host_name
                end
            end
            vnics = extracted_service_profile_names.to_s.scan(/ether-vNIC-(\w+)/)
            vnics.each do |vnic| #Ugly...refactor
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
          puts ui.list(macpool_list, :uneven_columns_across, 5)
        else
          puts "Incorrect options. Please make sure you are using one of the following: mac,uuid,wwpn"        
        end       
      end
    end
  end
end
