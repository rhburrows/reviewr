module Reviewr
  module CLI
    class Accept < Command
      def execute
        merge_branch = project.current_branch

        project.review_branch = arguments.first
        prompt_for_user
        project.fetch_review_branch
        project.fetch_master
        project.create_review_branch("origin/#{arguments.first}")
        unless project.rebase_review
          output.print "Branch '#{arguments.first}' won't merge cleanly"
        end
        project.change_branch(merge_branch)
        project.merge_commits
      end
    end
  end
end
