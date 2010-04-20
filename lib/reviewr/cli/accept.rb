module Reviewr
  module CLI
    class Accept < Command
      def execute
        project.review_branch = arguments.first
        prompt_for_user
        project.fetch_review_branch
      end
    end
  end
end
