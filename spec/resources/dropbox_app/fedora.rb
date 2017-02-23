# encoding: utf-8
# frozen_string_literal: true

require_relative '../dropbox_app'

shared_context 'resources::dropbox_app::fedora' do
  include_context 'resources::dropbox_app'

  let(:platform) { 'fedora' }

  shared_examples_for 'any Fedora platform' do
    it_behaves_like 'any platform'

    context 'the :install action' do
      include_context description

      context 'all default properties' do
        include_context description

        it 'adds the dropbox YUM repo' do
          expect(chef_run).to create_yum_repository('dropbox').with(
            baseurl: "https://linux.dropbox.com/fedora/#{platform_version}/",
            gpgkey: 'http://linux.dropbox.com/fedora/rpm-public-key.asc'
          )
        end

        it 'installs the default dropbox package' do
          expect(chef_run).to install_package('nautilus-dropbox')
        end
      end

      context 'an overridden source property' do
        include_context description

        it 'does not add the dropbox YUM repo' do
          expect(chef_run).to_not create_yum_repository('dropbox')
        end

        it 'installs the specified package' do
          expect(chef_run).to install_package(source)
        end
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes the dropbox package' do
        expect(chef_run).to remove_package('nautilus-dropbox')
      end

      it 'removes the dropbox YUM repo' do
        expect(chef_run).to remove_yum_repository('dropbox')
      end
    end
  end
end
