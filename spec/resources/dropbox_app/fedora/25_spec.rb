# encoding: utf-8
# frozen_string_literal: true

require_relative '../fedora'

describe 'resources::dropbox_app::fedora::25' do
  include_context 'resources::dropbox_app::fedora'

  let(:platform_version) { '25' }

  it_behaves_like 'any Fedora platform'
end
