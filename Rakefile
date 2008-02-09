require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + '/lib')
require 'facon'

Hoe.new('facon', Facon::VERSION) do |p|
  p.rubyforge_name = 'facon'
  p.author = 'Cheah Chu Yeow'
  p.email = 'chuyeow@gmail.com'
  p.summary = 'Tiny mocking library.'
  p.url = 'http://facon.rubyforge.org/'
  p.description = ' A mocking library in the spirit of the Bacon spec library. Small, compact, and works out of the box with Bacon.'
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.remote_rdoc_dir = '' # Release to root
  # p.clean_globs = ['test/actual'] # Remove this directory on "rake clean"
end
