# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_dropbox_fedora'

describe Chef::Provider::Dropbox::Fedora do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::Dropbox.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Fedora' do
      let(:platform) { { platform: 'fedora', version: '22' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    let(:node) do
      ChefSpec::Macros.stub_node('node.example',
                                 platform: 'fedora',
                                 version: '22')
    end
    let(:res) { described_class.provides?(node, new_resource) }
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
      [:package, :yum_repository].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    context 'no source override' do
      let(:source) { nil }

      it 'configures the dropbox YUM repo' do
        p = provider
        expect(p).to receive(:yum_repository).with('dropbox').and_yield
        expect(p).to receive(:baseurl)
          .with('https://linux.dropbox.com/fedora/22/')
        expect(p).to receive(:gpgkey)
          .with('http://linux.dropbox.com/fedora/rpm-public-key.asc')
        p.send(:install!)
      end

      it 'installs the dropbox package' do
        p = provider
        expect(p).to receive(:package).with('nautilus-dropbox')
        p.send(:install!)
      end
    end

    context 'a source override' do
      let(:source) { 'http://example.com/dropbox.rpm' }

      it 'does not configure the dropbox YUM repo' do
        p = provider
        expect(p).not_to receive(:yum_repository)
        p.send(:install!)
      end

      it 'installs dropbox from the package source' do
        p = provider
        expect(p).to receive(:package).with('http://example.com/dropbox.rpm')
        p.send(:install!)
      end
    end
  end

  describe '#remove!' do
    before(:each) do
      [:package, :yum_repository].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'removes the dropbox package' do
      p = provider
      expect(p).to receive(:package).with('nautilus-dropbox').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end

    it 'removes the dropbox repo' do
      p = provider
      expect(p).to receive(:yum_repository).with('dropbox').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end
end
