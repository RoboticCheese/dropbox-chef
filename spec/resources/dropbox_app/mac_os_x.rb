# encoding: utf-8
# frozen_string_literal: true

require_relative '../dropbox_app'

shared_context 'resources::dropbox_app::mac_os_x' do
  include_context 'resources::dropbox_app'

  let(:platform) { 'mac_os_x' }

  let(:http) { double }

  before(:each) do
    allow(http).to receive(:head)
      .with('https://www.dropbox.com/download?full=1&plat=mac')
      .and_return('https://example.com/db.dmg')
    allow(Net::HTTP).to receive(:start).with(
      'www.dropbox.com',
      443,
      use_ssl: true,
      ca_file: Chef::Config[:ssl_ca_file]
    ).and_yield(http)
  end

  shared_examples_for 'any MacOS platform' do
    it_behaves_like 'any platform'

    context 'the :install action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'installs the dropbox package' do
          expect(chef_run).to install_dmg_package('Dropbox').with(
            source: source || \
                    'https://www.dropbox.com/download?full=1&plat=mac',
            volumes_dir: 'Dropbox Installer'
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

      it 'kills the dropbox app' do
        expect(chef_run).to run_execute('killall Dropbox')
          .with(ignore_failure: true)
      end

      it 'deletes the dropbox directories' do
        %w(
          /Library/DropboxHelperTools
          /Applications/Dropbox.app
        ).each do |d|
          expect(chef_run).to delete_directory(d).with(recursive: true)
        end
      end
    end
  end
end
