# encoding: utf-8
# frozen_string_literal: true

require 'spec_helper'

class Chef
  class Resource
    # A fake windows_cookbook_package resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class WindowsCookbookPackage < Resource::LWRPBase
      self.resource_name = :windows_cookbook_package
      actions :install, :remove
      default_action :install
      attribute :source, kind_of: String
      attribute :installer_type, kind_of: Symbol
    end
  end
end
