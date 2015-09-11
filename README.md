Dropbox Cookbook
================
[![Cookbook Version](https://img.shields.io/cookbook/v/dropbox.svg)][cookbook]
[![Linux Build Status](https://img.shields.io/circleci/project/RoboticCheese/dropbox-chef.svg)][circle]
[![OS X Build Status](https://img.shields.io/travis/RoboticCheese/dropbox-chef.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/dropbox-chef.svg)][appveyor]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/dropbox-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/dropbox-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/dropbox
[circle]: https://circleci.com/gh/RoboticCheese/vlc-chef
[travis]: https://travis-ci.org/RoboticCheese/dropbox-chef
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/dropbox-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/dropbox-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/dropbox-chef

A Chef cookbook for installing the Dropbox application.

Requirements
============

This cookbook consumes the `dmg`, `windows`, `apt`, and `yum` community
cookbooks to support OS X, Windows, Debian/Ubuntu, and Fedora, respectively.

Usage
=====

Resources can be called directly, or the main recipe that uses those resources
can be added to your run\_list.

Note that this cookbook only installs the Dropbox application. A username and
password will still have to be entered in the UI the first time the application
is started.

Recipes
=======

***default***

Calls the `dropbox` resource to install Dropbox with a given set of attributes.

Attributes
==========

***default***

A custom package source path or URL can be provided.

    default['dropbox']['source'] = nil

Resources
=========

***dropbox***

Wraps the other Dropbox resources into a single parent resource.

Syntax:

    dropbox 'default' do
        source 'https://somewhere.org/dropbox.dmg'
        action :install
    end

Actions:

| Action     | Description                                |
|------------|--------------------------------------------|
| `:install` | Default; installs a `dropbox_app` resource |
| `:remove ` | Removes a `dropbox_app` resource           |

Attributes:

| Attribute | Default    | Description                                        |
|-----------|------------|----------------------------------------------------|
| source    | `nil`      | Pass an optional source to the child `dropbox_app` |
| action    | `:install` | The action to perform                              |


***dropbox_app***

Responsible for fetching and installing Dropbox application packages.

Syntax:

    dropbox_app 'default' do
        source 'https://somewhere.org/dropbox.dmg'
        action :install
    end

Actions:

| Action     | Description                               |
|------------|-------------------------------------------|
| `:install` | Default; installs the Dropbox application |
| `:remove ` | Uninstalls the Dropbox application        |

Attributes:

| Attribute | Default    | Description                                      |
|-----------|------------|--------------------------------------------------|
| source    | `nil`      | Fetch the Dropbox package from a custom path/URL |
| action    | `:install` | The action to perform                            |

Providers
=========

***Chef::Provider::Dropbox***

A parent provider that divvies up responsibilities between the child resources.

***Chef::Provider::DropboxApp***

A generic provider for all non-platform-specific functionality.

***Chef::Provider::DropboxApp::MacOsX***

Provides the Mac OS X platform support.

***Chef::Provider::DropboxApp::Windows***

Provides the Windows platform support.

***Chef::Provider::DropboxApp::Debian***

Provides the Debian and Ubuntu platform support.

***Chef::Provider::DropboxApp::Fedora***

Provides the Fedora platform support.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2014-2015 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
