$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'facon/mockable'
require 'facon/mock'
require 'facon/error_generator'
require 'facon/expectation'
require 'facon/proxy'
require 'facon/spec_methods'

require 'facon/core_ext/object'

module Facon
  VERSION = '0.1'
end