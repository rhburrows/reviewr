module Reviewr
  class Request
    def initialize(opts)
    end

    def call
      sha = Git.last_commit.slice(0,8)
      Git.create_branch("review_#{sha}")
    end
  end
end
