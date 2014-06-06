# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cgen/version'


Gem::Specification.new do |spec|

  spec.name          = 'cgen'
  spec.version       = CGen::VERSION
  spec.authors       = ['Alessandro Molari']
  spec.email         = ['molari.alessandro@gmail.com']
  spec.summary       = %q{Curriculum Vitae generator}
  spec.homepage      = 'http://github.com/alem0lars/cgen'
  spec.license       = 'Apache 2'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency     'hash-deep-merge'
  spec.add_runtime_dependency     'monadic'

  spec.add_runtime_dependency     'awesome_print'
  spec.add_runtime_dependency     'colorize'
  spec.add_runtime_dependency     'highline'

  spec.add_runtime_dependency     'erubis'

end
