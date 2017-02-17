# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dropbox
# Library:: provider_dropbox_app_windows
#
# Copyright 2014-2017, Jonathan Hartman
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

require_relative 'provider_dropbox_app'

class Chef
  class Provider
    class DropboxApp < Provider::LWRPBase
      # A Chef provider for Dropbox packages for Windows.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows < DropboxApp
        PATH ||= ::File.expand_path('/Program Files (x86)/Dropbox')

        provides :dropbox_app, platform_family: 'windows'

        private

        #
        # Use a windows_package resource to install the Dropbox app.
        #
        # (see Chef::Provider::DropboxApp#install!)
        #
        def install!
          s = source_path
          windows_package 'Dropbox' do
            source s
            installer_type :wise
          end
        end

        #
        # Use a windows_package resource to remove the Dropbox app.
        # The Windows uninstall script handles stopping a running service and
        # removing the Dropbox mount locations, so this action is all that's
        # needed.
        #
        # (see Chef::Provider::DropboxApp#remove!)
        #
        def remove!
          windows_package 'Dropbox' do
            action :remove
          end
        end
      end
    end
  end
end
