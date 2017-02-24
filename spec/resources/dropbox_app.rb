# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::dropbox_app' do
  include_context 'resources'

  let(:resource) { 'dropbox_app' }
  %i(source).each { |p| let(p) { nil } }
  let(:properties) { { source: source } }
  let(:name) { 'default' }

  shared_context 'the default action' do
  end

  shared_context 'the :install action' do
    let(:action) { nil }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden source property' do
    let(:source) { 'http://example.com/db.dmg' }
  end

  shared_examples_for 'any platform' do
    context 'the :install action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'installs a dropbox_app resource' do
          expect(chef_run).to install_dropbox_app(name)
        end
      end

      it_behaves_like 'any property set'
    end

    context 'the :remove action' do
      include_context description

      it 'removes a dropbox_app resource' do
        expect(chef_run).to remove_dropbox_app(name)
      end
    end
  end
end
