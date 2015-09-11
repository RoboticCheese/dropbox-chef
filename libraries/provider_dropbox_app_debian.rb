# Encoding: UTF-8
#
# Cookbook Name:: dropbox
# Library:: provider_dropbox_app_debian
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

require 'chef/dsl/include_recipe'
require_relative 'provider_dropbox_app'

class Chef
  class Provider
    class DropboxApp < Provider::LWRPBase
      # A Chef provider for Dropbox packages for Debian and Ubuntu Linux. The
      # only difference between the two is in the URL for their APT repos.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Debian < DropboxApp
        include Chef::DSL::IncludeRecipe

        provides :dropbox_app, platform_family: 'debian'

        private

        #
        # Configure the Dropbox APT repo and install the package.
        #
        # (see Chef::Provider::DropboxApp#install!)
        #
        def install!
          return package(new_resource.source) if new_resource.source
          include_recipe 'apt'
          repository(:add)
          package 'dropbox'
        end

        #
        # Remove the Dropbox package and APT repo
        #
        # (see Chef::Provider::DropboxApp#remove!)
        #
        def remove!
          package 'dropbox' do
            action :remove
          end
          repository(:remove)
        end

        #
        # Define an apt_repository resource for Dropbox for Ubuntu and pass it
        # a given action.
        #
        # @param action [Symbol] the Chef action to perform
        #
        def repository(action)
          apt_repository 'dropbox' do
            uri "http://linux.dropbox.com/#{node['platform']}"
            distribution node['lsb']['codename']
            components %w(main)
            keyserver 'pgp.mit.edu'
            key '5044912E'
            action action
          end
        end
      end
    end
  end
end