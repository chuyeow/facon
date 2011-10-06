$:.push File.expand_path('../lib', __FILE__)
require 'facon/version'

Gem::Specification.new do |s|
  s.name        = 'facon'
  s.version     = Facon::VERSION
  s.authors     = ['chuyeow']
  s.email       = ['chuyeow@gmail.com']
  s.homepage    = 'https://github.com/chuyeow/facon'
  s.summary     = %q{Tiny mocking library.}
  s.description = %q{A mocking library in the spirit of the Bacon spec library. Small, compact, and works with Bacon.}

  s.rubyforge_project = 'facon'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
