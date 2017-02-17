# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dropbox::default' do
  let(:overrides) { {} }
  let(:runner) do
    ChefSpec::ServerRunner.new do |node|
      overrides.each { |k, v| node.set['dropbox'][k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  context 'default attributes' do
    it 'installs Dropbox' do
      expect(chef_run).to install_dropbox('dropbox').with(source: nil)
    end
  end

  context 'an overridden `source` attribute' do
    let(:overrides) { { source: 'http://example.com/pkg.dmg' } }

    it 'installs from the desired package URL' do
      expect(chef_run).to install_dropbox('dropbox')
        .with(source: overrides[:source])
    end
  end
end
