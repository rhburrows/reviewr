module Reviewr
  module CLI
    class Main
      attr_reader :command, :args

      def initialize(args)
        @command = args.first
        @args = args.last(args.size - 1)
      end

      def run
        case command
        when "request"
          Request.new(args.first).call
        else
          Help.new.call
        end
      end
    end
  end
end
