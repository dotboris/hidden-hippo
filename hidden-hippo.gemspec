# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hidden_hippo/version'

Gem::Specification.new do |spec|
  spec.name          = 'hidden-hippo'
  spec.version       = HiddenHippo::VERSION
  spec.authors       = ['Boris Bera', 'Clément Zotti', 'François Genois', 'Ulrich Kossou']
  spec.email         = ['bboris@rsoft.ca', nil, nil, nil]
  spec.summary       = %q{A tool that identifies the people around by sniffing network traffic and mining social networks.}
  spec.homepage      = 'https://github.com/beraboris/hidden-hippo'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'shoulda-matchers', '~> 2.8'

  spec.add_dependency 'packetfu', '~> 1.1'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'sinatra', '~> 1.4'
  spec.add_dependency 'thin', '~> 1.6'
  spec.add_dependency 'mongoid', '~> 4.0'
end
