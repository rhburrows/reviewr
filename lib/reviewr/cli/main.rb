require 'termios'

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
        build_command.call
      end

      def build_command
        case command
        when "request"
          Request.new(project, @input, @output)
        else
          Help.new(project, @input, @output)
        end
      end
    end
  end
end
