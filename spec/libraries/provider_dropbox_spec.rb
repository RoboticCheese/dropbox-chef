# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_dropbox'

describe Chef::Provider::Dropbox do
  let(:platform) { { platform: 'mac_os_x', version: '10.9.2' } }
  let(:node) { Fauxhai.mock(platform).data }
  let(:package_url) { nil }
  let(:new_resource) do
    double(name: 'dropbox', package_url: package_url, :'installed=' => true)
  end
  let(:provider) { described_class.new(new_resource, nil) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:node).and_return(node)
  end

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#load_current_resource' do
    it 'returns a Dropbox resource instance' do
      expected = Chef::Resource::Dropbox
      expect(provider.load_current_resource).to be_an_instance_of(expected)
    end
  end

  describe '#action_install' do
    let(:remote_file) { double(run_action: true) }
    let(:package) { double(run_action: true) }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_file)
        .and_return(remote_file)
      allow_any_instance_of(described_class).to receive(:package)
        .and_return(package)
    end

    it 'downloads the package file' do
      expect(remote_file).to receive(:run_action).with(:create)
      provider.action_install
    end

    it 'installs the package file' do
      expect(package).to receive(:run_action).with(:install)
      provider.action_install
    end

    it 'sets installed to true' do
      expect(new_resource).to receive(:'installed=').with(true)
      provider.action_install
    end
  end

  describe '#package' do
    let(:package_resource_class) { Chef::Resource::Package }
    let(:download_dest) { 'somewhere' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:package_resource_class)
        .and_return(package_resource_class)
      allow_any_instance_of(described_class).to receive(:download_dest)
        .and_return(download_dest)
      allow_any_instance_of(described_class)
        .to receive(:tailor_package_to_platform).and_return(true)
    end

    it 'returns a package resource' do
      expected = Chef::Resource::Package
      expect(provider.send(:package)).to be_an_instance_of(expected)
    end

    it 'uses the correct file path' do
      expect(provider.send(:package).name).to eq(download_dest)
    end

    it 'calls the tailor method' do
      expect_any_instance_of(described_class)
        .to receive(:tailor_package_to_platform)
      provider.send(:package)
    end
  end

  describe '#remote_file' do
    let(:download_dest) { '/somewhere' }
    let(:download_source) { 'https://elsewhere.biz' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_dest)
        .and_return(download_dest)
      allow_any_instance_of(described_class).to receive(:download_source)
        .and_return(download_source)
    end

    it 'returns a remote_file resource' do
      expected = Chef::Resource::RemoteFile
      expect(provider.send(:remote_file)).to be_an_instance_of(expected)
    end

    it 'uses the correct file source' do
      expect(provider.send(:remote_file).source).to eq([download_source])
    end

    it 'uses the correct file destination' do
      expect(provider.send(:remote_file).name).to eq(download_dest)
    end
  end

  describe '#download_source' do
    before(:each) do
      expected = if package_url
                   package_url
                 else
                   'https://www.dropbox.com/download?full=1&plat=' <<
                   platform[:platform][0..2]
                 end
      allow_any_instance_of(described_class).to receive(:chase_redirect)
        .with(expected).and_return(expected)
    end

    context 'Mac OS X' do
      context 'no package_url override' do
        let(:package_url) { nil }

        it 'generates a download URL' do
          expected = 'https://www.dropbox.com/download?full=1&plat=mac'
          expect(provider.send(:download_source)).to eq(expected)
        end
      end

      context 'a package_url override' do
        let(:package_url) { 'https://example.com/z' }

        it 'uses the package_url' do
          expect(provider.send(:download_source)).to eq(package_url)
        end
      end
    end

    context 'Windows' do
      let(:platform) { { platform: 'windows', version: '2012R2' } }

      context 'no package_url override' do
        let(:package_url) { nil }

        it 'generates a download URL' do
          expected = 'https://www.dropbox.com/download?full=1&plat=win'
          expect(provider.send(:download_source)).to eq(expected)
        end
      end

      context 'a package_url override' do
        let(:package_url) { 'https://example.com/z' }

        it 'uses the package_url' do
          expect(provider.send(:download_source)).to eq(package_url)
        end
      end
    end
  end

  describe '#download_dest' do
    let(:download_source) { 'https://example.com/app%203.dmg' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_source)
        .and_return(download_source)
    end

    it 'returns the proper temp file path' do
      expected = "#{Chef::Config[:file_cache_path]}/app3.dmg"
      expect(provider.send(:download_dest)).to eq(expected)
    end
  end

  describe '#chase_redirect' do
    let(:response) { nil }
    let(:url) { 'https://example.com/somewhere' }
    let(:http) { double }

    before(:each) do
      uri = URI.parse(url)
      opts = { use_ssl: true, ca_file: nil }
      expect(http).to receive(:head).with(URI.parse(url)).and_return(response)
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
        expect(http).to receive(:head).with(URI.parse(suburl))
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
        expect(http).to receive(:head).with(URI.parse(subsuburl))
          .and_return(subsubresponse)
        expect(http).to receive(:head).with(URI.parse(suburl))
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
          allow(http).to receive(:head).with(URI.parse(uri))
            .and_return(r)
        end
      end

      it 'returns nil' do
        expect(provider.send(:chase_redirect, url)).to eq(nil)
      end
    end
  end
end
