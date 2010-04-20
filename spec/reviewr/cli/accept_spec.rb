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
      end
    end
  end
end
