Knife UCS (alpha)
===============

This is a Chef Knife plugin for Cisco UCS inspired by knife-openstack (Matt Ray @Opscode). This plugin gives knife the ability to provision, list, and manage Cisco UCS. It leverages UCSlib (http://github.com/murraju/ucslib). 

# Installation #

Be sure you are running the latest version Chef. Versions earlier than 0.10.0 don't support plugins:

    $ gem install chef

This plugin is distributed as a Ruby Gem. To install it, run:

    $ gem install knife-ucs

Depending on your system's configuration, you may need to run this command with root privileges.

# Configuration #

In order to communicate with Cisco UCS XML API you will have to tell Knife the username, password and the IP address of the UCS Manager. The easiest way to accomplish this is to create some entries in your `knife.rb` file:

    knife[:ucsm_username]   = "Your UCSM username"
    knife[:ucsm_password] 	= "Your UCSM password"
    knife[:ucsm_host]       = "Your IP address or UCSM hostname"

If your knife.rb file will be checked into a SCM system (ie readable by others) you may want to read the values from environment variables:

	knife[:ucsm_username]   = "#{ENV['UCSM_USERNAME']}"
    knife[:ucsm_password] 	= "#{ENV['UCSM_PASSWORD']}"
    knife[:ucsm_host]       = "#{ENV['UCSM_HOST']}"



# Subcommands #

This plugin provides the following Knife subcommands. Specific command options can be found by invoking the subcommand with a `--help` flag

Examples:

knife openstack ucs blades list
-----------------------------

List blade information:

	-> knife ucs blades list
	ID   Model         Serial  CPUs  Memory[MB]  Adaptors  EtnernetIfs  FCifs  Availability  Power
	1/6  N20-B6620-1   582     1     4096        1         2            0      available     off  
	1/2  N20-B6620-1   579     1     4096        1         2            2      available     off  
	1/7  N20-B6620-1   583     1     4096        1         2            2      available     off  
	1/8  N20-B6730-1   585     1     8192        1         0            0      unavailable   off  
	1/1  N20-B6620-1   577     2     8192        1         3            0      unavailable   on   
	1/5  N20-B6620-1   581     1     4096        1         2            2      available     off  
	1/3  B230-BASE-M2  578     1     16384       1         2            0      available     off  
	1/4  N20-B6620-1   580     1     4096        1         2            2      available     off  
	->



# License #

Author:: Murali Raju <murali.raju@appliv.com>

Copyright:: Copyright (c) 2012 Murali Raju.

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
