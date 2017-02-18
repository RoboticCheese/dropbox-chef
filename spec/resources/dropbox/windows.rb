# encoding: utf-8
# frozen_string_literal: true

require_relative '../dropbox'

describe 'resources::dropbox::windows' do
  include_context 'resources::dropbox'

  let(:platform) { 'windows' }

  shared_examples_for 'any Windows platform' do
    it_behaves_like 'any platform'
  end
end
