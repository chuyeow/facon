$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'facon/mockable'
require 'facon/mock'
require 'facon/error_generator'
require 'facon/expectation'
require 'facon/proxy'
require 'facon/baconize'

require 'facon/core_ext/object'

# Facon is a mocking library in the spirit of the Bacon spec library. Small,
# compact, and works with Bacon.
module Facon
  VERSION = '0.4.1'
end