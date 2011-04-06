# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniscient/version"

Gem::Specification.new do |s|
  s.name        = "omniscient"
  s.version     = Omniscient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alexandre de Oliveira"]
  s.email       = ["chavedomundo@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Manage DBs from your local machine.}
  s.description = %q{Clone DBs from one machine to another.}

  s.rubyforge_project = "omniscient"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
