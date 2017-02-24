# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dropbox::remove::package' do
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

  describe package('dropbox'), if: os[:family] == 'ubuntu' do
    it 'is not installed' do
      expect(subject).not_to be_installed
    end
  end

  describe package('nautilus-dropbox'), if: os[:family] == 'fedora' do
    it 'is not installed' do
      expect(subject).not_to be_installed
    end
  end
end
