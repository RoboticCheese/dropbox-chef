# Encoding: UTF-8

require_relative '../spec_helper'

describe 'Dropbox package' do
  it 'is installed' do
    case os[:family]
    when 'darwin'
      f = '/Applications/Dropbox.app/Contents/MacOS/Dropbox'
      expect(file(f)).to be_executable
    else
      fail('Unsupported platform')
    end
  end
end
