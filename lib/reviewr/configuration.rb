module Reviewr
  class Configuration
    attr_reader :from, :to, :git

    def initialize(to, git)
      @from, @to, @git = git.user_email, to, git
    end

    def review_sha
      @review_sha ||= git.last_commit.slice(0, 8)
    end

    def master_sha
      @master_sha ||= git.origin_master_commit.slice(0, 8)
    end

    def review_branch
      @review_branch ||= "review_#{review_sha}"
    end

    def user_email
      @user_email ||= git.user_email
    end
  end
end
