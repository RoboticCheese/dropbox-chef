# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_dropbox_app_debian'

describe Chef::Provider::DropboxApp::Debian do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::DropboxApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Debian' do
      let(:platform) { { platform: 'debian', version: '8.1' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'Ubuntu' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    before(:each) do
      [:include_recipe, :repository, :package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    context 'no source override' do
      let(:source) { nil }

      it 'refreshes the APT cache' do
        p = provider
        expect(p).to receive(:include_recipe).with('apt')
        p.send(:install!)
      end

      it 'configures the dropbox APT repo' do
        p = provider
        expect(p).to receive(:repository).with(:add)
        p.send(:install!)
      end

      it 'installs the dropbox packages' do
        p = provider
        expect(p).to receive(:package).with('dropbox')
        p.send(:install!)
      end
    end

    context 'a source override' do
      let(:source) { 'http://example.com/dropbox.deb' }

      it 'does nothing with the APT cache' do
        p = provider
        expect(p).not_to receive(:include_recipe)
        p.send(:install!)
      end

      it 'does not configure the dropbox APT repo' do
        p = provider
        expect(p).not_to receive(:repository)
        p.send(:install!)
      end

      it 'installs dropbox from the package source' do
        p = provider
        expect(p).to receive(:package).with('http://example.com/dropbox.deb')
        p.send(:install!)
      end
    end
  end

  describe '#remove!' do
    before(:each) do
      [:package, :repository].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'removes the dropbox packages' do
      p = provider
      expect(p).to receive(:package).with('dropbox').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end

    it 'removes the dropbox repo' do
      p = provider
      expect(p).to receive(:repository).with(:remove)
      p.send(:remove!)
    end
  end

  describe '#repository' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:action) { nil }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    shared_examples_for 'Ubuntu 14.04' do
      it 'passes the action to an apt_repository resource' do
        p = provider
        expect(p).to receive(:apt_repository).with('dropbox').and_yield
        expect(p).to receive(:uri).with('http://linux.dropbox.com/ubuntu')
        expect(p).to receive(:distribution).with('trusty')
        expect(p).to receive(:components).with(%w(main))
        expect(p).to receive(:keyserver).with('pgp.mit.edu')
        expect(p).to receive(:key).with('5044912E')
        expect(p).to receive(:action).with(action)
        p.send(:repository, action)
      end
    end

    shared_examples_for 'Debian 8.1' do
      it 'passes the action to an apt_repository resource' do
        p = provider
        expect(p).to receive(:apt_repository).with('dropbox').and_yield
        expect(p).to receive(:uri).with('http://linux.dropbox.com/debian')
        expect(p).to receive(:distribution).with('jessie')
        expect(p).to receive(:components).with(%w(main))
        expect(p).to receive(:keyserver).with('pgp.mit.edu')
        expect(p).to receive(:key).with('5044912E')
        expect(p).to receive(:action).with(action)
        p.send(:repository, action)
      end
    end

    [:add, :remove].each do |a|
      context "an #{a} action" do
        let(:action) { a }

        context 'Ubuntu 14.04' do
          let(:platform) { { platform: 'ubuntu', version: '14.04' } }

          it_behaves_like 'Ubuntu 14.04'
        end

        context 'Ubuntu Debian 8.1' do
          let(:platform) { { platform: 'debian', version: '8.1' } }

          it_behaves_like 'Debian 8.1'
        end
      end
    end
  end
end
