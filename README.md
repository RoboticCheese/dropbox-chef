Dropbox Cookbook
================
[![Cookbook Version](http://img.shields.io/cookbook/v/dropbox.svg)][cookbook]
[![Build Status](http://img.shields.io/travis/RoboticCheese/dropbox-chef.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/RoboticCheese/dropbox-chef.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/RoboticCheese/dropbox-chef.svg)][coveralls]

[cookbook]: https://supermarket.getchef.com/cookbooks/dropbox
[travis]: http://travis-ci.org/RoboticCheese/dropbox-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/dropbox-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/dropbox-chef

A Chef cookbook for installing the Dropbox application.

Requirements
============

This cookbook currently requires an OS X or Windows node. While Dropbox does
distribute packages for Linux, they are kept in a different download area with
a different API than the OS X and Windows packages.

It consumes the [dmg](https://supermarket.chef.io/cookbooks/dmg) and
[windows](https://supermarket.chef.io/cookbooks/windows) cookbooks to support
OS X and Windows installs.

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

Calls the `dropbox` resource to do a package install.

Attributes
==========

***default***

A custom package URL can be provided.

    default['dropbox']['package_url'] = nil

Resources
=========

***dropbox***

Wraps the fetching and installation of a remote package into one main resource.

Syntax:

    dropbox 'dropbox' do
        package_url 'https://somewhere.org/dropbox.dmg'
        action :install
    end

Actions:

| Action     | Description                               |
|------------|-------------------------------------------|
| `:install` | Default; installs the Dropbox application |

Attributes:

| Attribute   | Default    | Description                                   |
|-------------|------------|-----------------------------------------------|
| package_url | `nil`      | Optionally download package from a custom URL |
| action      | `:install` | The action to perform                         |

Providers
=========

***Chef::Provider::Dropbox***

A generic provider for all non-platform-specific functionality.

***Chef::Provider::Dropbox::MacOsX***

Provides the Mac OS X platform support.

***Chef::Provider::Dropbox::Windows***

Provides the Windows platform support.

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

Copyright 2014 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
