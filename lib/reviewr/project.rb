require 'forwardable'

module Reviewr
  class Project
    extend Forwardable

    attr_reader :from, :to, :git
    attr_accessor :user_email, :email_password

    def_delegators :git, :push_branch, :origin_location

    def initialize(to, git = Git.instance)
      @from, @to, @git = git.user_email, to, git
    end

    def create_review_branch
      git.create_branch(review_branch)
    end

    def create_review_commit(msg)
      git.commit(msg)
    end

    def push_review_branch
      git.push_branch(review_branch)
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
