require 'spec_helper'

module Reviewr
  module CLI
    describe Request do
      let(:project) { double("Project").as_null_object }
      let(:mailer) { double("Mailer").as_null_object }
      let(:request) { Request.new(project) }

      describe "#call" do
        before do
          Mailer.stub!(:new).and_return(mailer)
        end

        it "creates a branch for review" do
          project.should_receive(:create_review_branch)
          request.call
        end

        it "creates a commit of review meta-data" do
          request.stub(:commit_msg).and_return("commit")
          project.should_receive(:create_review_commit).with("commit")
          request.call
        end

        it "pushes the review branch" do
          project.should_receive(:push_review_branch)
          request.call
        end

        it "sends a email request for the code review" do
          request.stub(:email_body).and_return("email")
          mailer.should_receive(:send).with("email")
          request.call
        end

        it "changes branches back to the original" do
          project.stub!(:current_branch).and_return("original")
          project.should_receive(:change_branch).with("original")
          request.call
        end
      end

      describe "#compare_url" do
        it "uses github compare from the master sha to the review sha" do
          project.stub(:origin_location).and_return('test:repo')
          project.stub(:master_sha).and_return('1')
          project.stub(:review_sha).and_return('2')
          request.compare_url.should == "http://github.com/repo/1...2"
        end
      end

      describe "#commit_msg" do
        MSG= <<-END
Code Review Request
===================
requested_by: email@site.com
requested_from: reviewer@site.com
      END

        it "generates the commit message based on the to/from addresses" do
          project.stub(:user_email).and_return("email@site.com")
          project.stub(:to).and_return("reviewer@site.com")
          request.commit_msg.should == MSG
        end
      end

      describe "#email_body" do
        BODY= <<-END
Hi,

Could you please code review and comment on the following changes:

compare url

If you find the changes acceptable please run:
  reviewr accept review_12345678
If you think more work needs to be done please run:
  reviewr reject review_12345678

Thanks!
        END

        it "generates the email body based on the project" do
          request.stub(:compare_url).and_return("compare url")
          project.stub(:review_branch).and_return("review_12345678")
          request.email_body.should == BODY
        end
      end
    end
  end
end
