# encoding: utf-8
# frozen_string_literal: true

require_relative '../debian'

describe 'resources::dropbox::debian::8_6' do
  include_context 'resources::dropbox::debian'

  let(:platform_version) { '8.6' }

  it_behaves_like 'any Debian platform'
end
