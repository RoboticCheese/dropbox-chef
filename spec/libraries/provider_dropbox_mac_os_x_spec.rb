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
end
