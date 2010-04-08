require 'spec_helper'

module Reviewr
  describe Project do
    let(:git){ double("Git", :user_email => "email") }
    let(:project){ Project.new("to@site.com", git) }

    describe "#review_sha" do
      it "returns the first 8 characters of the last commit" do
        git.stub!(:last_commit).and_return('12345678123e324')
        project.review_sha.should == '12345678'
      end
    end

    describe "#master_sha" do
      it "returns the first 8 characters of the origin master commit" do
        git.stub!(:origin_master_commit).and_return('876543213672482637we7682')
        project.master_sha.should == '87654321'
      end
    end

    describe "#email_server" do
      it "pulls the domain from the user's email" do
        project.user_email = "email@site.com"
        project.email_server.should == "site.com"
      end
    end

    describe "#review_branch" do
      it "appends the review_sha to 'review_'" do
        project.stub!(:review_sha).and_return('12345678')
        project.review_branch.should == 'review_12345678'
      end
    end

    describe "#create_review_branch" do
      it "creates the branch with the name from #review_branch" do
        project.stub(:review_branch).and_return('branch')
        git.should_receive(:create_branch).with('branch')
        project.create_review_branch
      end
    end

    describe "#push_review_branch" do
      it "pushes the branch with the name from #review_branch" do
        project.stub(:review_branch).and_return('branch')
        git.should_receive(:push_branch).with('branch')
        project.push_review_branch
      end
    end

    describe "#create_review_commit" do
      it "creates a commit with the passed commit message" do
        git.should_receive(:commit).with('commit msg')
        project.create_review_commit('commit msg')
      end
    end
  end
end
