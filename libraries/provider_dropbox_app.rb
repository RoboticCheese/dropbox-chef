# Encoding: UTF-8
#
# Cookbook Name:: dropbox
# Library:: provider_dropbox_app
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

require 'chef/provider/lwrp_base'
require 'chef-config/path_helper'
require 'net/http'
require_relative 'provider_dropbox_app_mac_os_x'
require_relative 'provider_dropbox_app_windows'
require_relative 'provider_dropbox_app_debian'
require_relative 'provider_dropbox_app_fedora'

class Chef
  class Provider
    # A Chef provider for the OS-independent pieces of Dropbox packages.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DropboxApp < Provider::LWRPBase
      use_inline_resources

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Install the Dropbox app.
      #
      action :install do
        install!
      end

      #
      # Uninstall the Dropbox app.
      #
      action :remove do
        remove!
      end

      private

      #
      # Do the actual app installation, tailored to the specific platform.
      #
      # @raise [NotImplementedError] if not defined for this provider
      #
      def install!
        fail(NotImplementedError,
             "`install!` method must be implemented for #{self.class} provider")
      end

      #
      # Do the actual app removal, tailored to the specific platform.
      #
      # @raise [NotImplementedError] if not defined for this provider
      #
      def remove!
        fail(NotImplementedError,
             "`remove!` method must be implemented for #{self.class} provider")
      end

      #
      # Determine the source file path or download URL for the Dropbox package.
      # This is pulled from their download page for the current platform by
      # default, but can be overridden with the `source` attribute.
      #
      # @return [String]
      #
      def source_path
        @source_path ||= begin
          return new_resource.source unless new_resource.source.nil?
          params = URI.encode_www_form(full: 1,
                                       plat: node['platform_family'][0..2])
          chase_redirect("https://www.dropbox.com/download?#{params}")
        end
      end

      #
      # Recursively follow redirects to an eventual package URL. Dropbox's
      # download links can lead through multiple levels of redirects before
      # finally getting to an actual package.
      #
      # @param [String] url
      # @return [String]
      #
      def chase_redirect(url)
        u = URI.parse(url)
        10.times do
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
