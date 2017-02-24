# encoding: utf-8
# frozen_string_literal: true

require_relative '../debian'

describe 'resources::dropbox_app::ubuntu::14_04' do
  include_context 'resources::dropbox_app::debian'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }
  let(:platform_codename) { 'trusty' }

  it_behaves_like 'any Debian platform'
end
