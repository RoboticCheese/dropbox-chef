# encoding: utf-8
# frozen_string_literal: true

require_relative '../debian'

describe 'resources::dropbox_app::debian::8_6' do
  include_context 'resources::dropbox_app::debian'

  let(:platform_version) { '8.6' }
  let(:platform_codename) { 'jessie' }

  it_behaves_like 'any Debian platform'
end
