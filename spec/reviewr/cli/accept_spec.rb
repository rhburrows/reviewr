require 'spec_helper'

module Reviewr
  module CLI
    describe Accept do
      let(:project){ double("Project").as_null_object }
      let(:accept){ Accept.new(project) }

      describe "#call" do
        before do
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
          project.should_receive(:create_review_branch).with("origin/review")
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
        end
      end
    end
  end
end
