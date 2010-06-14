module Reviewr
  module CLI
    class Accept < Command
      def execute
        merge_branch = project.current_branch

        project.review_branch = arguments.first
        prompt_for_user
        project.fetch_review_branch
        project.fetch_master
        project.create_review_branch("#{project.remote_repo}/#{arguments.first}")

        unless project.rebase_review
          output.print "Branch '#{arguments.first}' won't merge cleanly"
        else
          # This must be run while on the review branch
          project.to = project.requester_email

          project.change_branch(merge_branch)
          project.merge_commits
          project.push_branch(merge_branch)
          project.delete_remote_review_branch

          Mailer.new(project).send(email_body)
        end
      end

      def email_body
        read_template('accept_email.erb')
      end
    end
  end
end
