# Encoding: UTF-8

include_recipe 'dropbox'

dropbox 'default' do
  action :remove
end
