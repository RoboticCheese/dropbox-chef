# Encoding: UTF-8

require_relative '../spec_helper'

describe 'Dropbox package' do
  describe file('/Applications/Dropbox.app'), if: os[:family] == 'darwin' do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end

  describe package('Dropbox'), if: os[:family] == 'windows' do
    it 'is not installed' do
      expect(subject).not_to be_installed
    end
  end
end
