# Encoding: UTF-8
#
# Cookbook Name:: dropbox
# Library:: provider_dropbox
#
# Copyright 2014 Jonathan Hartman
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

require 'chef/provider'
require 'net/http'
require_relative 'provider_dropbox_mac_os_x'
require_relative 'provider_dropbox_windows'

class Chef
  class Provider
    # A Chef provider for the OS-independent pieces of Dropbox packages
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Dropbox < Provider
      #
      # WhyRun is supported by this provider
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Load and return the current resource
      #
      # @return [Chef::Resource::Dropbox]
      #
      def load_current_resource
        @current_resource ||= Resource::Dropbox.new(new_resource.name)
      end

      #
      # Download and install the Dropbox package
      #
      def action_install
        remote_file.run_action(:create)
        package.run_action(:install)
        new_resource.installed = true
      end

      private

      #
      # The package resource for the package
      #
      # @return [Chef::Resource::Package, Chef::Resource::DmgPackage]
      #
      def package
        unless @package
          @package = package_resource_class.new(download_dest, run_context)
          tailor_package_to_platform
        end
        @package
      end

      #
      # The remote file resource for downloading the package file
      #
      # @return [Chef::Resource::RemoteFile]
      #
      def remote_file
        unless @remote_file
          @remote_file = Resource::RemoteFile.new(download_dest, run_context)
          @remote_file.source(download_source)
        end
        @remote_file
      end

      #
      # The source to download the package from
      #
      # @return [String]
      #
      def download_source
        unless @download_source
          if new_resource.package_url
            res = chase_redirect(new_resource.package_url)
          else
            params = URI.encode_www_form(full: 1,
                                         plat: node['platform_family'][0..2])
            res = chase_redirect("https://www.dropbox.com/download?#{params}")
          end
        end
        @download_source ||= res
      end

      #
      # The filesystem path to download the package to and install from
      #
      # @return [String]
      #
      def download_dest
        ::File.join(Chef::Config[:file_cache_path],
                    ::File.basename(URI.decode(download_source)).gsub(' ', ''))
      end

      #
      # Recursively follow redirects to an eventual package URL
      #
      # @param [String] url
      # @return [String]
      #
      def chase_redirect(url)
        u = URI.parse(url)
        (0..9).each do
          opts = { use_ssl: u.scheme == 'https',
                   ca_file: Chef::Config[:ssl_ca_file] }
          resp = Net::HTTP.start(u.host, u.port, opts) { |h| h.head(u.to_s) }
          return u.to_s unless resp.is_a?(Net::HTTPRedirection)
          u = URI.parse(resp['location'])
        end
        nil
      end
    end
  end
end
