require 'rubygems'
require 'pony'
require 'erb'

require 'reviewr/request'
require 'reviewr/help'
require 'reviewr/git'

module Reviewr
  class << self
    def run(args)
      case args.first
      when "request"
        Reviewr::Request.new(args.last(args.size - 1)).call
      else
        Reviewr::Help.new.call
      end
    end
  end
end
