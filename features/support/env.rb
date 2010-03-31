$LOAD_PATH << 'lib'
require 'reviewr'

class MockGit
  attr_reader :commands

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

Reviewr::Git.instance = MockGit.new
