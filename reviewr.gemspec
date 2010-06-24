# Thanks to Yehuda Katz for good gemspec info
# http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended/
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'reviewr/version'

Gem::Specification.new do |s|
  s.name        = "reviewr"
  s.version     = Reviewr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = "Ryan Burrows"
  s.email       = "rhburrows@gmail.com"
  s.homepage    = "http://github.com/rhburrows/reviewr"
  s.summary     = "Easy git code reviews"
  s.description = <<-DESC
    Reviewr makes git code reviews easy using Github to manage code and comments
  DESC

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "thor"
  s.add_dependency "grit"

  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "fakefs"

  s.files = File.readlines("Manifest.txt").inject([]) do |files, line|
    files << line.chomp
  end
  s.executables  = ['reviewr']
  s.require_path = 'lib'
end
