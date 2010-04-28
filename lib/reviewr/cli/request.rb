require 'erb'
require 'forwardable'

module Reviewr
  module CLI
    class Request < Command
      def execute
        project.to = arguments.first
        prompt_for_user
        original_branch = project.current_branch
        project.create_review_branch
        project.create_review_commit(commit_msg)
        project.push_review_branch
        Mailer.new(project).send(email_body)
        project.change_branch(original_branch)
      end

      def compare_url
        repo = project.origin_location.split(':')[1].gsub(/.git$/, "/compare")
        "http://github.com/#{repo}/#{project.master_sha}...#{project.review_sha}"
      end

      def commit_msg
        read_template('commit_msg.erb')
      end

      def email_body
        read_template('request_email.erb')
      end
    end
  end
end
