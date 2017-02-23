# encoding: utf-8
# frozen_string_literal: true

name 'dropbox'
maintainer 'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license 'Apache v2.0'
description 'Installs Dropbox'
long_description 'Installs Dropbox'
version '0.1.1'
chef_version '>= 12.6'

source_url 'https://github.com/roboticcheese/dropbox-chef'
issues_url 'https://github.com/roboticcheese/dropbox-chef/issues'

depends 'dmg', '~> 3.1'

supports 'mac_os_x'
supports 'windows'
supports 'ubuntu'
supports 'debian'
supports 'fedora'
