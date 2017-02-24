# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dropbox
# Library:: resource_dropbox_app_fedora
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

require_relative 'resource_dropbox_app'

class Chef
  class Resource
    # A Chef resource for Dropbox packages for Fedora Linux.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DropboxAppFedora < Resource::DropboxApp
      provides :dropbox_app, platform: 'fedora'

      #
      # Configure the Dropbox YUM repo and install the package.
      #
      action :install do
        if new_resource.source
          package new_resource.source
        else
          yum_repository 'dropbox' do
            baseurl 'https://linux.dropbox.com/fedora/' \
                    "#{node['platform_version']}/"
            gpgkey 'http://linux.dropbox.com/fedora/rpm-public-key.asc'
          end
          package 'nautilus-dropbox'
        end
      end

      #
      # Remove the Dropbox package and YUM repo.
      #
      action :remove do
        package('nautilus-dropbox') { action :remove }
        yum_repository('dropbox') { action :remove }
      end
    end
  end
end
