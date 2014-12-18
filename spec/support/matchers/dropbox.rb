# Encoding: UTF-8

require 'spec_helper'

module ChefSpec
  module API
    # Some simple matchers for the dropbox resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    module DropboxMatchers
      ChefSpec.define_matcher :dropbox

      def install_dropbox(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:dropbox,
                                                :install,
                                                resource_name)
      end
    end
  end
end
