require 'spec_helper'

module Reviewr
  module CLI
    describe Accept do
      let(:project){ double("Project").as_null_object }
      let(:accept){ Accept.new(project) }
      let(:mailer){ double("Mailer").as_null_object }

      describe "#call" do
        before do
          Mailer.stub(:new).and_return(mailer)
          accept.stub(:prompt_for_user)
          accept.arguments = []
          accept.output = double("Output").as_null_object
        end

        it "sets the review_branch" do
          project.should_receive(:review_branch=).with("review_branch")
          accept.arguments = ["review_branch"]
          accept.call
        end

        it "prompts for user information" do
          accept.should_receive(:prompt_for_user)
          accept.call
        end

        it "fetches the remote branch" do
          project.should_receive(:fetch_review_branch)
          accept.call
        end

        it "fetches the remote master" do
          project.should_receive(:fetch_master)
          accept.call
        end

        it "creates a working branch for the reviewed code" do
          project.should_receive(:remote_repo).and_return("some_other_repo")
          project.should_receive(:create_review_branch).with("some_other_repo/review")
          accept.arguments = ["review"]
          accept.call
        end

        it "rebases the review branch on the master branch" do
          project.should_receive(:rebase_review)
          accept.call
        end

        context "rebase is successful" do
          before do
            project.stub(:rebase_review).and_return(true)
          end

          it "changes back to the original git branch" do
            project.stub(:current_branch).and_return('master')
            project.should_receive(:change_branch).with('master')
            accept.call
          end

          it "merges in the extra commits from the review branch" do
            project.should_receive(:merge_commits)
            accept.call
          end

          it "pushes the merged branch to the remote" do
            project.stub(:current_branch).and_return('current')
            project.should_receive(:push_branch).with("current")
            accept.call
          end

          it "deletes the reviewed branch from the remote" do
            project.should_receive(:delete_remote_review_branch)
            accept.call
          end

          it "sets the to address to the review requester's" do
            project.stub(:requester_email).and_return("coder@site.com")
            project.should_receive(:to=).with("coder@site.com")
            accept.call
          end

          it "sends an email to the review requester" do
            accept.stub(:email_body).and_return("email")
            mailer.should_receive(:send).with("email")
            accept.call
          end
        end
      end

      describe "#email_body" do
        THE_BODY= <<-END
Hi,

I have reviewed your changes for branch review_12345678 and decided to
merge them in.

Thanks!
        END

        it "generates the email body based on the project" do
          project.stub(:review_branch).and_return("review_12345678")
          accept.email_body.should == THE_BODY
        end
      end
    end
  end
end
