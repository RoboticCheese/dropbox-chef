# encoding: utf-8
# frozen_string_literal: true

name 'dropbox'
maintainer 'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license 'Apache v2.0'
description 'Installs Dropbox'
long_description 'Installs Dropbox'
version '0.1.1'

source_url 'https://github.com/roboticcheese/dropbox-chef'
issues_url 'https://github.com/roboticcheese/dropbox-chef/issues'

depends 'dmg', '~> 2.2'
depends 'windows', '~> 1.36'
depends 'yum', '~> 3.7'
depends 'apt', '~> 2.8'

supports 'mac_os_x'
supports 'windows'
supports 'ubuntu'
supports 'debian'
supports 'fedora'
