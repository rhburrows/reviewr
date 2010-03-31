require 'spec_helper'

module Reviewr
  describe Request do
    describe "#call" do
      before do
        Git.stub!(:create_branch)
        Git.stub!(:commit)
        Git.stub!(:user_email)
        Git.stub!(:push_branch)
      end

      it "creates a git branch named 'review_sha'" do
        Git.stub!(:last_commit).and_return("1234567812345678123456781234567812345678")
        Git.should_receive(:create_branch).with("review_12345678")
        Request.new("").call
      end

      MSG= <<-END
Code Review Request
===================
requested_by: email@site.com
requested_from: reviewer@site.com
      END

      it "creates a commit with review metadata" do
        Git.stub!(:user_email).and_return("email@site.com")
        Git.should_receive(:commit).with(MSG)
        Request.new("reviewer@site.com").call
      end

      it "pushes the review branch to origin" do
        Git.stub!(:last_commit).and_return("12345678123456781234567812345678")
        Git.should_receive(:push_branch).with("review_12345678")
        Request.new("").call
      end
    end
  end
end
