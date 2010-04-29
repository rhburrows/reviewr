require 'spec_helper'

module Reviewr
  describe Project do
    let(:git){ double("Git", :user_email => "email") }
    let(:project){ Project.new(git) }

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

    describe "#rebase_review" do
      it "rebases the review branch on the remote master" do
        git.stub(:remote_repo).and_return('remote')
        git.should_receive(:rebase).with('remote/master', 'review')
        project.stub(:review_branch).and_return('review')
        project.rebase_review
      end
    end

    describe "#fetch_review_branch" do
      it "fetches the branch with the name from #review_branch" do
        project.stub(:review_branch).and_return('branch')
        git.should_receive(:fetch).with('branch')
        project.fetch_review_branch
      end
    end

    describe "#fetch_master" do
      it "fetches the master" do
        git.should_receive(:fetch).with('master')
        project.fetch_master
      end
    end

    describe "#create_review_branch" do
      it "creates the branch with the name from #review_branch" do
        project.stub(:review_branch).and_return('branch')
        git.should_receive(:create_branch).with('branch', anything)
        project.create_review_branch
      end

      it "bases the branch on the parameter if specified" do
        project.stub(:review_branch)
        git.should_receive(:create_branch).with(anything, 'base')
        project.create_review_branch('base')
      end

      it "bases the branch on the master by default" do
        project.stub(:review_branch)
        git.should_receive(:create_branch).with(anything, 'master')
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
