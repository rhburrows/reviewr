require 'spec_helper'

module Reviewr
  describe Git do
    let(:git) { Git.new }

    describe "#last_commit" do
      it "shells out to git to the get the hash of the last commit" do
        git.stub!(:execute).and_return("")
        git.should_receive(:execute).with('git show --pretty=format:"%H" HEAD')
        git.last_commit
      end

      it "cuts out the first line (sha)" do
        git.stub!(:execute).and_return("12345678\nblah\nblah\nblah")
        git.last_commit.should == "12345678"
      end
    end

    describe "#create_branch" do
      it "creates a new branch through git" do
        git.should_receive(:execute).with('git checkout -b branch_name')
        git.create_branch("branch_name")
      end
    end

    describe "#current_branch" do
      it "looks at the current branches" do
        git.should_receive(:execute).with('git branch').and_return("")
        git.current_branch
      end

      it "returns the branch with a '*' by its name" do
        git.stub(:execute).and_return("one\n* two\nthree")
        git.current_branch.should == "two"
      end
    end

    describe "#change_branch" do
      it "checks out the branch" do
        git.should_receive(:execute).with('git checkout branch_name')
        git.change_branch('branch_name')
      end
    end

    describe "#commit" do
      it "creates an empty commit with the message" do
        git.should_receive(:execute).with('git commit --allow-empty -m "my message"')
        git.commit("my message")
      end
    end

    describe "#user_email" do
      it "looks up the user's email in the git config" do
        git.should_receive(:execute).with('git config user.email')
        git.user_email
      end
    end

    describe "#push_branch" do
      it "pushes the branch to origin" do
        git.should_receive(:execute).with('git push origin branch_name')
        git.push_branch("branch_name")
      end
    end

    describe "#origin_location" do
      it "runs show on the remote remote repo" do
        git.remote_repo = "origin"
        git.should_receive(:execute).with('git remote show origin')
        git.origin_location
      end

      SHOW = <<-END
* remote origin
  URL: git@github.com:rhburrows/reviewr.git
  Tracked remote branch
    master
      END

      it "parses out the URL" do
        git.stub!(:execute).and_return(SHOW)
        git.origin_location.should == "git@github.com:rhburrows/reviewr.git"
      end
    end

    describe "#origin_master_commit" do
      it "calls ls-remote on the origin master" do
        git.should_receive(:execute).with('git ls-remote origin refs/heads/master')
        git.origin_master_commit
      end

      it "returns only the sha" do
        git.stub!(:execute).and_return("12345678123456781234567812345678        refs/heads/master")
        git.origin_master_commit.should == "12345678123456781234567812345678"
      end
    end
  end
end
