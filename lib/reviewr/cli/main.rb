require 'termios'

module Reviewr
  module CLI
    class Main
      attr_reader :command, :c
      attr_accessor :arguments

      def initialize(args, input = STDIN, output = STDOUT)
        @command = args.shift
        @arguments = args
        @input, @output = input, output
      end

      def run
        build_command.call
      end

      def build_command
        unless @c
          case command
          when "request"
            @c = Request.new(Project.new, @input, @output)
          when "accept"
            @c = Accept.new(Project.new, @input, @output)
          else
            @c = Help.new(Project.new, @input, @output)
          end

          @c.arguments = arguments
        end
        @c
      end
    end
  end
end
