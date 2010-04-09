require 'termios'
require 'ruby-debug'

module Reviewr
  module CLI
    class Main
      attr_reader :command
      attr_accessor :project

      def initialize(args, input = STDIN, output = STDOUT)
        @command = args.shift
        @project = Project.new(args.shift)
        @input, @output = input, output
      end

      def run
        case command
        when "request"
          prompt_for_user(@input, @output)
          Request.new(project).call
        else
          #FIXME
          Help.new.call(project.to)
        end
      end

      def prompt_for_user(input = STDIN, output = STDOUT)
        output.print("Email (default #{project.user_email}): ")
        email = input.gets.chomp
        project.user_email = email unless email.empty?

        output.print("Email password: ")
        no_echo(input) do
          project.email_password = input.gets.chomp
        end
        output.print("\n")

        output.print("Remote repository (default origin): ")
        repo = input.gets.chomp
        project.remote_repo = repo unless repo.empty?
      end

      private

      #TODO, should this be somewhere better?
      def no_echo(input)
        oldt = Termios.tcgetattr(input)
        newt = oldt.dup
        newt.lflag &= ~Termios::ECHO
        Termios.tcsetattr(input, Termios::TCSANOW, newt)

        yield

        Termios.tcsetattr(input, Termios::TCSANOW, oldt)
      end
    end
  end
end
