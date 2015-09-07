# Encoding: UTF-8
#
# Cookbook Name:: dropbox
# Library:: provider_dropbox_mac_os_x
#
# Copyright 2014-2015 Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'provider_dropbox'

class Chef
  class Provider
    class Dropbox < Provider::LWRPBase
      # A Chef provider for Dropbox for Mac OS X.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < Dropbox
        PATH ||= '/Applications/Dropbox.app'

        provides :dropbox, platform_family: 'mac_os_x'

        private

        #
        # Use a dmg_package resource to install the Dropbox app.
        #
        # (see Chef::Provider::Dropbox#install!)
        #
        def install!
          s = source_path
          dmg_package 'Dropbox' do
            source s
            volumes_dir 'Dropbox Installer'
          end
        end

        #
        # In the absence of an uninstall script for OS X, kill any running
        # instance of Dropbox and delete its directories.
        #
        # (see Chef::Provider::Dropbox#remove!)
        #
        def remove!
          execute 'killall Dropbox' do
            ignore_failure true
          end
          [::File.expand_path('/Library/DropboxHelperTools'),
           ::File.expand_path(PATH)].each do |d|
            directory d do
              recursive true
              action :delete
            end
          end
        end
      end
    end
  end
end
