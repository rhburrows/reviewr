require 'reviewr/request'
require 'reviewr/git'

module Reviewr
  class << self
    def run(command)
      args = command.split(' ')
      Reviewr::Request.new(args.last(args.size - 1)).call
    end
  end
end
