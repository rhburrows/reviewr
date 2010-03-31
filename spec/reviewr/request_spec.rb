require 'spec_helper'

module Reviewr
  describe Request do
    describe "#call" do
      before do
        Git.stub!(:create_branch)
        Git.stub!(:commit)
        Git.stub!(:user_email)
        Git.stub!(:push_branch)
        Git.stub!(:origin_location).and_return("asdf:fdas")
        Git.stub!(:origin_master_commit).and_return("")
        Pony.stub!(:mail)
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

      context "sending email" do
        it "sends it from the user's email" do
          Git.stub!(:user_email).and_return("email@site.com")
          Pony.should_receive(:mail).with(hash_including(:from => "email@site.com"))
          Request.new("").call
        end

        it "sends it to the to address" do
          Pony.should_receive(:mail).with(hash_including(:to => "reviewer@site.com"))
          Request.new("reviewer@site.com").call
        end

        BODY= <<-END
Hi,

Could you please code review and comment on the following changes:

http://github.com/rhburrows/reviewr/compare/87654321...12345678

If you find the changes acceptable please run:
  reviewr accept review_12345678
If you think more work needs to be done please run:
  reviewr reject review_12345678

Thanks!
        END

        it "Formats the body with the github URL" do
          Git.stub!(:origin_location).and_return("git@github.com:rhburrows/reviewr.git")
          Git.stub!(:origin_master_commit).and_return("87654321876543218765432187654321")
          Git.stub!(:last_commit).and_return("12345678123456781234567812345678")
          Pony.should_receive(:mail).with(hash_including(:body => BODY))
          Request.new("reviewer@site.com").call
        end
      end
    end
  end
end
