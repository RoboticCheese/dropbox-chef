# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_dropbox'

describe Chef::Provider::Dropbox do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::Dropbox.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_install' do
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    shared_examples_for 'any attribute set' do
      it 'passes the source on and installs dropbox_app resource' do
        p = provider
        expect(p).to receive(:dropbox_app).with(name).and_yield
        expect(p).to receive(:source).with(source)
        p.action_install
      end
    end

    context 'no source override' do
      let(:source) { nil }

      it_behaves_like 'any attribute set'
    end

    context 'a source override' do
      let(:source) { 'https://example.com/z' }

      it_behaves_like 'any attribute set'
    end
  end

  describe '#action_remove' do
    it 'removes a dropbox_app resource' do
      p = provider
      expect(p).to receive(:dropbox_app).with(name).and_yield
      expect(p).to receive(:action).with(:remove)
      p.action_remove
    end
  end
end
