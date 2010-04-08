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
          Help.new.call
        end
      end

      def prompt_for_user(input = STDIN, output = STDOUT)
        output.puts("Email (default #{project.user_email}): ")
        email = input.gets.chomp
        project.user_email = email unless email.empty?

        output.puts("Email password: ")
        no_echo(input) do
          project.email_password = input.gets.chomp
        end

        output.puts("Email server (default #{project.email_server}): ")
        server = input.gets.chomp
        project.email_server = server unless server.empty?
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
