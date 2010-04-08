module Reviewr
  module CLI
    class Main
      attr_reader :command
      attr_accessor :project

      def initialize(args)
        @command = args.shift
        @project = Project.new(args.shift)
      end

      def run
        case command
        when "request"
          Request.new(project).call
        else
          Help.new.call
        end
      end

      def prompt_for_user(input, output)
        output.puts("Email (default #{project.user_email}): ")
        email = input.gets.chomp
        project.user_email = email unless email.empty?

        output.puts("Email password: ")
        project.email_password = input.gets.chomp

        project
      end
    end
  end
end
