require 'forwardable'

module Reviewr
  class Project
    extend Forwardable

    attr_reader :git, :email_server
    attr_accessor :email_password, :to
    attr_writer :user_email, :review_branch

    def_delegators :git, :push_branch, :origin_location, :remote_repo,
                   :remote_repo=, :current_branch, :change_branch

    def initialize(git = Git.instance)
      @git = git
    end

    def create_review_branch(base = 'master')
      git.create_branch(review_branch, base)
      git.change_branch(review_branch)
    end

    def rebase_review
      git.rebase(current_branch, review_branch)
    end

    def fetch_review_branch
      git.fetch(review_branch)
    end

    def fetch_master
      git.fetch('master')
    end

    def create_review_commit(msg)
      git.commit(msg)
    end

    def push_review_branch
      git.push_branch(review_branch)
    end

    def review_sha
      @review_sha ||= git.last_commit_sha.slice(0, 8)
    end

    def review_subject
      @review_subject ||= git.last_commit_subject
    end

    def review_body
      @review_body ||= git.last_commit_body
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

    def merge_commits
      git.cherry(current_branch, review_branch).split(/\n/).each do |line|
        git.cherry_pick(line.split(/\s/)[1])
      end
    end

    def delete_remote_review_branch
      git.push_branch(":#{review_branch}")
    end

    def requester_email
      msg = git.log(1)
      if msg
        m = msg.match(/requested_by: ([^\s]+)/)
        m && m[1]
      end
    end
  end
end
