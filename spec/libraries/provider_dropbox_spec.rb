# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_dropbox'

describe Chef::Provider::Dropbox do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::Dropbox.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_install' do
    it 'installs the app' do
      p = provider
      expect(p).to receive(:install!)
      p.action_install
    end
  end

  describe '#install!' do
    it 'raises an error' do
      expect { provider.send(:install!) }.to raise_error(NotImplementedError)
    end
  end

  describe '#source_path' do
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end
    let(:platform) { nil }
    let(:node) { Fauxhai.mock(platform).data }
    let(:chase_redirect) { "http://example.com/#{platform[:platform]}.pkg" }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
      allow_any_instance_of(described_class).to receive(:chase_redirect)
        .with('https://www.dropbox.com/download?full=1&plat=' <<
              platform[:platform][0..2]).and_return(chase_redirect)
    end

    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.9.2' } }

      context 'no source override' do
        let(:source) { nil }

        it 'returns a download URL' do
          expected = 'http://example.com/mac_os_x.pkg'
          expect(provider.send(:source_path)).to eq(expected)
        end
      end

      context 'a source override' do
        let(:source) { 'https://example.com/z' }

        it 'uses the source' do
          expect(provider.send(:source_path)).to eq(source)
        end
      end
    end

    context 'Windows' do
      let(:platform) { { platform: 'windows', version: '2012R2' } }

      context 'no source override' do
        let(:source) { nil }

        it 'generates a download URL' do
          expected = 'http://example.com/windows.pkg'
          expect(provider.send(:source_path)).to eq(expected)
        end
      end

      context 'a source override' do
        let(:source) { 'https://example.com/z' }

        it 'uses the source' do
          expect(provider.send(:source_path)).to eq(source)
        end
      end
    end
  end

  describe '#chase_redirect' do
    let(:response) { nil }
    let(:url) { 'https://example.com/somewhere' }
    let(:http) { double }

    before(:each) do
      uri = URI.parse(url)
      opts = { use_ssl: true, ca_file: nil }
      expect(http).to receive(:head).with(url).and_return(response)
      allow(Net::HTTP).to receive(:start).with(uri.host, uri.port, opts)
        .and_yield(http)
    end

    context 'no redirect' do
      let(:response) { Net::HTTPResponse.new(1, 200, 'hi') }

      it 'returns the same URL' do
        expect(provider.send(:chase_redirect, url)).to eq(url)
      end
    end

    context 'a single level of redirect' do
      let(:suburl) { 'https://example.com/elsewhere' }
      let(:subresponse) { Net::HTTPResponse.new(1, 200, 'hi') }
      let(:response) do
        r = Net::HTTPRedirection.new(1, 302, 'hi')
        r['location'] = suburl
        r
      end

      before(:each) do
        expect(http).to receive(:head).with(suburl)
          .and_return(subresponse)
      end

      it 'follows the redirect' do
        expect(provider.send(:chase_redirect, url)).to eq(suburl)
      end
    end

    context 'multiple levels of redirects' do
      let(:subsuburl) { 'https://example.com/pt3' }
      let(:subsubresponse) { Net::HTTPResponse.new(1, 200, 'hi') }

      let(:suburl) { 'https://example.com/pt2' }
      let(:subresponse) do
        r = Net::HTTPRedirection.new(1, 302, 'hi')
        r['location'] = subsuburl
        r
      end

      let(:response) do
        r = Net::HTTPRedirection.new(1, 302, 'hi')
        r['location'] = suburl
        r
      end

      before(:each) do
        expect(http).to receive(:head).with(subsuburl)
          .and_return(subsubresponse)
        expect(http).to receive(:head).with(suburl)
          .and_return(subresponse)
      end

      it 'follows all the redirects' do
        expect(provider.send(:chase_redirect, url)).to eq(subsuburl)
      end
    end

    context 'too many levels of redirects' do
      let(:response) do
        r = Net::HTTPRedirection.new(1, 302, 'hi')
        r['location'] = 'https://example.com/pt0'
        r
      end

      before(:each) do
        (0..10).each do |i|
          uri = "https://example.com/pt#{i}"
          r = Net::HTTPRedirection.new(1, 302, 'hi')
          r['location'] = "https://example.com/pt#{i + 1}"
          allow(http).to receive(:head).with(uri)
            .and_return(r)
        end
      end

      it 'returns nil' do
        expect(provider.send(:chase_redirect, url)).to eq(nil)
      end
    end
  end
end
