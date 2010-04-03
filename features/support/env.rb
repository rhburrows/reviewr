$LOAD_PATH << 'lib'
require 'reviewr'

class MockGit < Reviewr::Git
  attr_accessor :commands

  def initialize
    @responses = {}
    @commands = []
  end

  def execute(cmd)
    @commands << cmd
    @responses[cmd] || ""
  end

  def register(cmd, response)
    @responses[cmd] = response
  end
end

class MockPony
  class << self
    def mail(opts)
      @sent = opts
    end

    def sent
      @sent ||= {}
    end
  end
end

Reviewr::Git.instance = MockGit.new
# Ugly stubbing so cucumber isn't sending email
Pony.class_eval("def self.mail(opts = {}); MockPony.mail(opts); end")
Pony.class_eval("def self.sent; MockPony.sent; end")
