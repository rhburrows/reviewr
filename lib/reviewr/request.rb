module Reviewr
  class Request
    def initialize(to_address)
      @to_address = to_address
    end

    def call
      sha = Git.last_commit.slice(0,8)
      Git.create_branch("review_#{sha}")
      Git.commit(commit_msg)
    end

    private

    def commit_msg
      <<-END
Code Review Request
===================
requested_by: #{Git.user_email}
requested_from: #{@to_address}
      END
    end
  end
end
