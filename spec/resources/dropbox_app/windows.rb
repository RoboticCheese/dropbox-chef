# encoding: utf-8
# frozen_string_literal: true

require_relative '../dropbox_app'

describe 'resources::dropbox_app::windows' do
  include_context 'resources::dropbox_app'

  let(:platform) { 'windows' }

  let(:http) { double }

  before(:each) do
    allow(http).to receive(:head)
      .with('https://www.dropbox.com/download?full=1&plat=win')
      .and_return('https://example.com/db.exe')
    allow(Net::HTTP).to receive(:start).with(
      'www.dropbox.com',
      443,
      use_ssl: true,
      ca_file: Chef::Config[:ssl_ca_file]
    ).and_yield(http)
  end

  shared_examples_for 'any Windows platform' do
    it_behaves_like 'any platform'

    context 'the :install action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'installs the dropbox package' do
          expect(chef_run).to install_windows_package('Dropbox').with(
            source: source || 'https://example.com/db.exe',
            installer_type: :wise
          )
        end
      end

      context 'all default properties' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden source property' do
        include_context description

        it_behaves_like 'any property set'
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes the dropbox package' do
        expect(chef_run).to remove_windows_package('Dropbox')
      end
    end
  end
end
