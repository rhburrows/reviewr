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

    describe "#merge_commits" do
      before do
        project.stub(:current_branch).and_return('master')
        project.stub(:review_branch).and_return('branch')
        git.stub(:cherry).and_return("")
      end

      it "lists the commit difference between the branches" do
        git.should_receive(:cherry).with('master', 'branch')
        project.merge_commits
      end

      it "cherry-picks each new commit" do
        git.stub(:cherry).and_return("+ 1234\n+ 5432")
        git.should_receive(:cherry_pick).with("1234")
        git.should_receive(:cherry_pick).with("5432")
        project.merge_commits
      end
    end

    describe "#delete_remote_review_branch" do
      it "pushes nothing over the remote review branch" do
        git.should_receive(:push_branch).with(':branch_name')
        project.stub(:review_branch).and_return('branch_name')
        project.delete_remote_review_branch
      end
    end

    describe "#requester_email" do
      it "reads the last commit message from git" do
        git.should_receive(:log).with(1)
        project.requester_email
      end

      it "parses out the requester email and returns it" do
        git.stub(:log).and_return([ "commit 1234567891234567823467",
                                    "Author: Cody McCoder",
                                    "Date:   Tue Apr 27 22:35:55 2010 -0700",
                                    "",
                                    "Code Review Request",
                                    "===================",
                                    "requested_by: coder@site.com",
                                    "requested_from: reviewer@site.com"
                                  ].join("\n"))
        project.requester_email.should == "coder@site.com"
      end
    end
  end
end
