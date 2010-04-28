module Reviewr
  module CLI
    class Command
      attr_reader :project
      attr_accessor :input, :output, :arguments

      def initialize(project, input = STDIN, output = STDOUT)
        @project = project
        @input, @output = input, output
      end

      def call
        execute
      end

      def prompt_for_user
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

      def read_template(name)
        @templates ||= {}
        @templates[name] ||= ERB.new(File.read(File.join(File.dirname(__FILE__),
                                                         '..',
                                                         'templates',
                                                         name)))
        @templates[name].result(binding)
      end

      private

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
