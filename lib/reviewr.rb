require 'rubygems'
require 'bundler'

Bundler.setup
require 'reviewr/cli'
require 'reviewr/git'
require 'reviewr/mailer'
require 'reviewr/project'
require 'reviewr/version'

module Reviewr
end
