# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dropbox
# Library:: provider_dropbox
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

require 'chef/provider/lwrp_base'
require_relative 'resource_dropbox_app'

class Chef
  class Provider
    # A Chef parent provider for Dropbox app + config + service.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Dropbox < Provider::LWRPBase
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
        dropbox_app new_resource.name do
          source new_resource.source
        end
      end

      #
      # Uninstall the Dropbox app.
      #
      action :remove do
        dropbox_app new_resource.name do
          action :remove
        end
      end
    end
  end
end
