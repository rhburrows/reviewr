require 'erb'
require 'forwardable'

module Reviewr
  module CLI
    class Request
      extend Forwardable

      attr_reader :git, :to, :config

      def_delegators :config, :review_sha, :master_sha, :review_branch, :user_email

      def initialize(to_or_config, git = Git.instance)
        if to_or_config.is_a? Configuration
          @config = to_or_config
        else
          @config = Configuration.new(to_or_config, git)
          @to, @git = to_or_config, git
        end
      end

      def call
        git.create_branch(review_branch)
        git.commit(commit_msg)
        git.push_branch(review_branch)
        Mailer.new(config).send(email_body)
      end

      def compare_url
        repo = git.origin_location.split(':')[1].gsub(/.git$/, "/compare")
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
        @templates[name] ||= ERB.new(File.read(File.join(File.dirname(__FILE__), '..', 'templates', name)))
        @templates[name].result(binding)
      end
    end
  end
end
