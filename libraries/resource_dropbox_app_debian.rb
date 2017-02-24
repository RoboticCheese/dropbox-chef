# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dropbox
# Library:: resource_dropbox_app_debian
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
    # A Chef resource for Dropbox packages for Debian and Ubuntu Linux. The
    # only difference between the two is in the URL for their APT repos.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DropboxAppDebian < Resource::DropboxApp
      provides :dropbox_app, platform_family: 'debian'

      #
      # Configure the Dropbox APT repo and install the package.
      #
      action :install do
        if new_resource.source
          package new_resource.source
        else
          apt_repository 'dropbox' do
            uri "http://linux.dropbox.com/#{node['platform']}"
            distribution node['lsb']['codename']
            components %w(main)
            keyserver 'pgp.mit.edu'
            key '5044912E'
          end
          package 'dropbox'
        end
      end

      #
      # Remove the Dropbox package and APT repo.
      #
      #
      action :remove do
        package('dropbox') { action :remove }
        apt_repository('dropbox') { action :remove }
      end
    end
  end
end
