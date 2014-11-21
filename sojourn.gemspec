lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sojourn/version'

Gem::Specification.new do |spec|
  spec.name          = 'sojourn'
  spec.version       = Sojourn::VERSION
  spec.authors       = ['Smudge']
  spec.email         = ['nathan@ngriffith.com']
  spec.summary       = 'Simple user source tracking for Rails.'
  spec.description   = %(
Sojourn tracks site visitors and sources, with the ability to recognise
multiple sources per visitor. Each time a new source is detected,
sojourn tracks the referer, utm data, and logged-in user (if any)).gsub("\n", ' ')
  spec.homepage      = ''
  spec.license       = ''

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'browser', '>= 0.8.0'
end
