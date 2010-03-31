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
      repo = Git.origin_location.split(':')[1].gsub(/.git$/, "/compare")
      "http://github.com/#{repo}/#{master_sha}...#{review_sha}"
    end

    def commit_msg
      read_template('commit_msg.erb')
    end

    def email_body
      read_template('request_email.erb')
    end

    def read_template(name)
      @templates ||= {}
      @templates[name] ||= ERB.new(File.read(File.join(File.dirname(__FILE__), 'templates', name)))
      @templates[name].result(binding)
    end
  end
end
