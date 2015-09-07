# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_dropbox_mac_os_x'

describe Chef::Provider::Dropbox::MacOsX do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::Dropbox.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'PATH' do
    it 'returns the app directory' do
      expect(described_class::PATH).to eq('/Applications/Dropbox.app')
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.10' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:source_path)
        .and_return('http://example.com/dropbox.dmg')
    end

    it 'uses a dmg_package to install Dropbox' do
      p = provider
      expect(p).to receive(:dmg_package).with('Dropbox').and_yield
      expect(p).to receive(:source).with('http://example.com/dropbox.dmg')
      expect(p).to receive(:volumes_dir).with('Dropbox Installer')
      p.send(:install!)
    end
  end

  describe '#remove!' do
    before(:each) do
      [:execute, :directory].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'kills any running Dropbox instance' do
      p = provider
      expect(p).to receive(:execute).with('killall Dropbox').and_yield
      expect(p).to receive(:ignore_failure).with(true)
      p.send(:remove!)
    end

    it 'deletes the Dropbox directories' do
      p = provider
      [
        File.expand_path('/Library/DropboxHelperTools'),
        '/Applications/Dropbox.app'
      ].each do |d|
        expect(p).to receive(:directory).with(d).and_yield
        expect(p).to receive(:recursive).with(true)
        expect(p).to receive(:action).with(:delete)
      end
      p.send(:remove!)
    end
  end
end
