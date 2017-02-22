# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dropbox
# Library:: resource_dropbox_app
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

require 'net/http'
require 'chef/resource'

class Chef
  class Resource
    # A Chef resource for Dropbox packages.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class DropboxApp < Resource
      default_action :install

      #
      # Property to allow an override of the default package source path/ URL.
      #
      property :source, String

      #
      # Determine the source file path or download URL for the Dropbox package.
      # This is pulled from their download page for the current platform by
      # default, but can be overridden with the `source` attribute.
      #
      # @return [String]
      #
      def source_path
        @source_path ||= begin
          return source unless source.nil?
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
