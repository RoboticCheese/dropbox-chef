# encoding: utf-8
# frozen_string_literal: true

require_relative '../dropbox_app'

describe 'resources::dropbox_app::debian' do
  include_context 'resources::dropbox_app'

  let(:platform) { 'debian' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'

    context 'the :install action' do
      include_context description

      context 'all default properties' do
        include_context description

        it 'adds the dropbox APT repo' do
          expect(chef_run).to add_apt_repository('dropbox').with(
            uri: "http://linux.dropbox.com/#{platform}",
            distribution: platform_codename,
            components: %w(main),
            keyserver: 'pgp.mit.edu',
            key: '5044912E'
          )
        end

        it 'installs the default dropbox package' do
          expect(chef_run).to install_package('dropbox')
        end
      end

      context 'an overridden source property' do
        include_context description

        it 'does not add the dropbox APT repo' do
          expect(chef_run).to_not add_apt_repository('dropbox')
        end

        it 'installs the specified package' do
          expect(chef_run).to install_package(source)
        end
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes the dropbox package' do
        expect(chef_run).to remove_package('dropbox')
      end

      it 'removes the dropbox APT repo' do
        expect(chef_run).to remove_apt_repository('dropbox')
      end
    end
  end
end
