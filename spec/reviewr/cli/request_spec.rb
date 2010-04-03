require 'spec_helper'

module Reviewr
  module CLI
    describe Request do
      let(:git) { double("Git").as_null_object }
      let(:request) { Request.new("reviewer@site.com", git) }

      describe "#call" do
        before do
          git.stub!(:origin_location).and_return("asdf:fdas")
          git.stub!(:origin_master_commit).and_return("")
          Pony.stub!(:mail)
        end

        it "creates a git branch named 'review_sha'" do
          git.stub!(:last_commit).and_return("1234567812345678123456781234567812345678")
          git.should_receive(:create_branch).with("review_12345678")
          request.call
        end

        MSG= <<-END
Code Review Request
===================
requested_by: email@site.com
requested_from: reviewer@site.com
      END

        it "creates a commit with review metadata" do
          git.stub!(:user_email).and_return("email@site.com")
          git.should_receive(:commit).with(MSG)
          request.call
        end

        it "pushes the review branch to origin" do
          git.stub!(:last_commit).and_return("12345678123456781234567812345678")
          git.should_receive(:push_branch).with("review_12345678")
          request.call
        end

        context "sending email" do
          it "sends it from the user's email" do
            git.stub!(:user_email).and_return("email@site.com")
            Pony.should_receive(:mail).with(hash_including(:from => "email@site.com"))
            request.call
          end

          it "sends it to the to address" do
            Pony.should_receive(:mail).with(hash_including(:to => "reviewer@site.com"))
            request.call
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
            git.stub!(:origin_location).and_return("git@github.com:rhburrows/reviewr.git")
            git.stub!(:origin_master_commit).and_return("87654321876543218765432187654321")
            git.stub!(:last_commit).and_return("12345678123456781234567812345678")
            Pony.should_receive(:mail).with(hash_including(:body => BODY))
            request.call
          end
        end
      end
    end
  end
end
