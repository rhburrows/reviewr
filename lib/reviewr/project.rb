require 'forwardable'

module Reviewr
  class Project
    extend Forwardable

    attr_reader :to, :git, :email_server
    attr_accessor :email_password
    attr_writer :user_email

    def_delegators :git, :push_branch, :origin_location, :remote_repo,
                   :remote_repo=

    def initialize(to, git = Git.instance)
      @to, @git = to, git
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

    def email_server
      @email_server ||= user_email.split('@')[1]
    end
  end
end
