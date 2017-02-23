# encoding: utf-8
# frozen_string_literal: true

require_relative '../dropbox'

shared_context 'resources::dropbox::debian' do
  include_context 'resources::dropbox'

  let(:platform) { 'debian' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
