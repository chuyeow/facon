require 'rubygems'
begin
  require 'bacon'
rescue LoadError
  require 'mac_bacon'
end

lib_path = File.expand_path("#{File.dirname(__FILE__)}/../lib")
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'facon'
