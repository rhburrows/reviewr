module Reviewr
  module CLI
    class Help
      def call(command)
        if command.nil?
          usage
        else
          request_help
        end
      end

      def usage
        puts <<-HELP
usage: reviewr COMMAND [ARGS]

reviewr commands
  request   Request a code review
  help      Find out more about a specific command

See 'reviewr help COMMAND' for more information on a specific command.
        HELP
      end

      def request_help
        puts <<-HELP
usage: reviewr request <email>

Request a code review from <email>.
        HELP
      end
    end
  end
end
