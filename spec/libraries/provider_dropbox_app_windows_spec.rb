# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../libraries/provider_dropbox_app_windows'

describe Chef::Provider::DropboxApp::Windows do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::DropboxApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = File.expand_path('/Program Files (x86)/Dropbox')
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Windows' do
      let(:platform) { { platform: 'windows', version: '2012R2' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:source_path)
        .and_return('http://example.com/dropbox.exe')
    end

    it 'uses a windows_package to install Dropbox' do
      p = provider
      expect(p).to receive(:windows_package).with('Dropbox').and_yield
      expect(p).to receive(:source).with('http://example.com/dropbox.exe')
      expect(p).to receive(:installer_type).with(:wise)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'uses a windows_package to remove Dropbox' do
      p = provider
      expect(p).to receive(:windows_package).with('Dropbox').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end
end
