Facon
=====

Facon is a mocking library in the spirit of the Bacon spec library. Small, compact, and works with Bacon.

[![Build Status](https://travis-ci.org/chuyeow/facon.png)](https://travis-ci.org/chuyeow/facon])

Synopsis
--------

To use Facon with [Bacon](https://github.com/chneukirchen/bacon), simply `require 'facon'` and you're done.

You can now write Bacon specs like this (in RSpec-like style):

  require 'bacon'
  require 'facon'

  describe 'PersonController' do
    before do
      @konata = mock('konata', :id => 1, :name => 'Konata Izumi')
      @kagami = mock('kagami', :id => 2, :name => 'Kagami Hiiragi')
    end

    it "should find all people on GET to 'index'" do
      Person.should.receive(:find).with(:all).and_return([@konata, @kagami])

      get('/people/index')
    end

    it "should find the person with id of 1 on Get to 'show/1'" do
      Person.should.receive(:find).with(1).and_return(@konata)

      get('/people/show/1')
    end
  end

For now, more examples can be found in the specs included with the Facon gem. I promise to get better examples into the
documentation!

See Facon::Baconize for more documentation on using Facon with [Bacon](https://github.com/chneukirchen/bacon).

Requirements
------------

* Ruby (check [Travis CI builds](https://travis-ci.org/chuyeow/facon) for which versions are supported)
* Bacon (optional, required for running specs)

Compatibility with Bacon
------------------------

When used with Bacon, Facon uses some Bacon hooks, which unfortunately causes some compatibility issues with new
versions of Bacon. Use this compatibility chart to find out which versions of Facon to install when running with Bacon.

Facon version -- Bacon version
<= 0.3.x      -- 0.9 (only tested with 0.9 but might work with earlier versions of Bacon)
0.4           -- 1.0, 1.1

Installation
------------

Simply install the gem:
  `gem install facon`

Or add it to your Gemfile:
  `gem 'bacon'`

The Source Code
---------------

You can get the latest trunk from the Git repository on Github:
  <git://github.com/chuyeow/facon.git>

Todos
-----

* test/unit and RSpec integration.
* Remove the $facon_mocks global.
* Throw away unnecessary code.
* Implement exactly, at_least, at_most expectations.

Contributors
------------

* [James Tucker](https://github.com/raggi) for #times, #once, #never expectation matchers.
* [Yossef Mendelssohn](https://github.com/ymendel) for Ruby 1.9.2 compatibility fixes.

Thanks to
---------

* [RSpec](http://rspec.info/) for creating spec/mocks, from which a lot of the code for Facon is stolen.
* Christian Neukirchen for creating Bacon.

License
-------

(The MIT License)

Copyright (c) 2008 Cheah Chu Yeow

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
