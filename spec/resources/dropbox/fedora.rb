# encoding: utf-8
# frozen_string_literal: true

require_relative '../dropbox'

describe 'resources::dropbox::fedora' do
  include_context 'resources::dropbox'

  let(:platform) { 'fedora' }

  shared_examples_for 'any Fedora platform' do
    it_behaves_like 'any platform'
  end
end
