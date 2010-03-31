module Reviewr
  class Request
    def initialize(arguments)
      @to_address = arguments.first
    end

    def call
      Git.create_branch(review_branch)
      Git.commit(commit_msg)
      Git.push_branch(review_branch)
      Pony.mail(:from => user_email,
                :to   => @to_address,
                :body => email_body)
    end

    private

    def review_sha
      @review_sha ||= Git.last_commit.slice(0, 8)
    end

    def master_sha
      @master_sha ||= Git.origin_master_commit.slice(0, 8)
    end

    def review_branch
      @review_branch ||= "review_#{review_sha}"
    end

    def user_email
      @user_email ||= Git.user_email
    end

    def compare_url
      # git@github.com:rhburrows/reviewr.git
      repo = Git.origin_location.split(':')[1].gsub(/.git$/, "/compare")
      "http://github.com/#{repo}/#{master_sha}...#{review_sha}"
    end

    def commit_msg
      <<-END
Code Review Request
===================
requested_by: #{user_email}
requested_from: #{@to_address}
      END
    end

    def email_body
      <<-END
Hi,

Could you please code review and comment on the following changes:

#{compare_url}

If you find the changes acceptable please run:
  reviewr accept #{review_branch}
If you think more work needs to be done please run:
  reviewr reject #{review_branch}

Thanks!
      END
    end
  end
end
