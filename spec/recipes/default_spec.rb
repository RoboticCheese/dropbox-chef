# Encoding: UTF-8

require_relative '../spec_helper'

describe 'dropbox::default' do
  let(:platform) { { platform: 'mac_os_x', version: '10.10' } }
  let(:overrides) { {} }
  let(:runner) do
    ChefSpec::ServerRunner.new(platform) do |node|
      overrides.each { |k, v| node.set['dropbox'][k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  context 'default attributes' do
    it 'installs Dropbox' do
      expect(chef_run).to install_dropbox('dropbox').with(package_url: nil)
    end
  end

  context 'an overridden `package_url attribute' do
    let(:overrides) { { package_url: 'http://example.com/pkg.dmg' } }

    it 'installs from the desired package URL' do
      expect(chef_run).to install_dropbox('dropbox')
        .with(package_url: overrides[:package_url])
    end
  end
end
