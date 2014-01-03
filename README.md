Facon
=====

Facon is a mocking library in the spirit of the [Bacon](https://github.com/chneukirchen/bacon) spec library. Small, compact, and works with [Bacon](https://github.com/chneukirchen/bacon) and [MacBacon](https://github.com/alloy/MacBacon).

[![Build Status](https://travis-ci.org/chuyeow/facon.png)](https://travis-ci.org/chuyeow/facon)

[![Coverage Status](https://coveralls.io/repos/chuyeow/facon/badge.png)](https://coveralls.io/r/chuyeow/facon)

Synopsis
--------

To use Facon with [Bacon](https://github.com/chneukirchen/bacon), simply `require 'facon'` and you're done.

You can now write [Bacon](https://github.com/chneukirchen/bacon) specs like this (in RSpec-like style):

```ruby
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

    it "knows how many times we call a method" do
      Person.should.receive(:find).at_least(3)

      Person.list
    end

    it "can use at_most" do
      Person.should.receive(:find).at_most(3)

      Person.list
    end
  end
```

For now, more examples can be found in the specs included with the Facon gem. I promise to get better examples into the documentation!

See Facon::Baconize for more documentation on using Facon with [Bacon](https://github.com/chneukirchen/bacon).

Requirements
------------

* Ruby (check [Travis CI builds](https://travis-ci.org/chuyeow/facon) for which versions are supported)
* [Bacon](https://github.com/chneukirchen/bacon) (optional, required for running specs)

Compatibility with Bacon
------------------------

When used with Bacon, Facon uses some Bacon hooks, which unfortunately causes some compatibility issues with new versions of Bacon. Use this compatibility chart to find out which versions of Facon to install when running with Bacon.

```
Facon version -- Bacon version
<= 0.3.x      -- 0.9 (only tested with 0.9 but might work with earlier versions of Bacon)
0.4           -- 1.0, 1.1
```

Installation
------------

Simply install the gem:
  `gem install facon`

Or add it to your Gemfile:
  `gem 'facon'`

The Source Code
---------------

You can get the latest trunk from the Git repository on Github:
  <https://github.com/chuyeow/facon>

Todos
-----

* test/unit and RSpec integration.
* Remove the `$facon_mocks` global.
* Throw away unnecessary code.
* Implement `exactly` expectation.

Contributors
------------

* [James Tucker](https://github.com/raggi) for #times, #once, #never expectation matchers.
* [Peter Kim](https://github.com/petejkim) for [MacBacon](https://github.com/alloy/MacBacon) support.
* [Yossef Mendelssohn](https://github.com/ymendel) for Ruby 1.9.2 compatibility fixes.
* [Ivan Acosta-Rubio](https://github.com/ivanacostarubio) for at_most and at_least expectations.

Thanks to
---------

* [RSpec](http://rspec.info/) for creating spec/mocks, from which a lot of the code for Facon is stolen.
* [Christian Neukirchen]((https://github.com/chneukirchen) for creating Bacon.

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


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/chuyeow/facon/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![Analytics](https://ga-beacon.appspot.com/UA-46828034-1/facon/readme)](https://github.com/igrigorik/ga-beacon)
