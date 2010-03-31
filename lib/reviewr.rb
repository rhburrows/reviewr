require 'rubygems'
require 'pony'

require 'reviewr/request'
require 'reviewr/git'

module Reviewr
  class << self
    def run(args)
      Reviewr::Request.new(args.last(args.size - 1)).call
    end
  end
end
