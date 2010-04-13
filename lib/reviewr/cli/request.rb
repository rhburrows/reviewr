require 'erb'
require 'forwardable'

module Reviewr
  module CLI
    class Request
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def call
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

      private

      def read_template(name)
        @templates ||= {}
        @templates[name] ||= ERB.new(File.read(File.join(File.dirname(__FILE__),
                                                         '..',
                                                         'templates',
                                                         name)))
        @templates[name].result(binding)
      end
    end
  end
end
