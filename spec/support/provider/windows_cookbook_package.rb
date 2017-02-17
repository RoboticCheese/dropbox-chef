# encoding: utf-8
# frozen_string_literal: true

require 'spec_helper'

class Chef
  class Provider
    # A fake windows_cookbook_package provider
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class WindowsCookbookPackage < Provider::LWRPBase
    end
  end
end
