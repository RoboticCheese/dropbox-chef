# Encoding: UTF-8

require_relative '../spec_helper'

describe 'Dropbox package' do
  describe file('/Applications/Dropbox.app'), if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end

  describe package('Dropbox'), if: os[:family] == 'windows' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe package('dropbox'), if: os[:family] == 'ubuntu' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe package('nautilus-dropbox'), if: os[:family] == 'fedora' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
