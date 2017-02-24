# encoding: utf-8
# frozen_string_literal: true

include_recipe 'dropbox'

dropbox 'default' do
  action :remove
end
