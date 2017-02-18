# encoding: utf-8
# frozen_string_literal: true

require_relative '../dropbox'

describe 'resources::dropbox::mac_os_x' do
  include_context 'resources::dropbox'

  let(:platform) { 'mac_os_x' }

  shared_examples_for 'any MacOS platform' do
    it_behaves_like 'any platform'
  end
end
