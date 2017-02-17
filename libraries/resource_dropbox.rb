# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dropbox
# Library:: resource_dropbox
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

require 'chef/resource/lwrp_base'
require_relative 'provider_dropbox'

class Chef
  class Resource
    # A Chef parent resource for Dropbox app + config + service.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class Dropbox < Resource::LWRPBase
      self.resource_name = :dropbox
      actions :install, :remove
      default_action :install

      #
      # Attribute for a package source path/URL to pass to the child
      # dropbox_app resource.
      #
      attribute :source, kind_of: String, default: nil
    end
  end
end
