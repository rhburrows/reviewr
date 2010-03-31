require 'spec_helper'

module Reviewr
  describe Git do
    describe "#last_commit" do
      it "shells out to git to the get the hash of the last commit" do
        Git.stub!(:execute).and_return("")
        Git.should_receive(:execute).with('git show --pretty=format:"%H" HEAD')
        Git.last_commit
      end

      it "cuts out the first line (sha)" do
        Git.stub(:execute).and_return("12345678\nblah\nblah\nblah")
        Git.last_commit.should == "12345678"
      end
    end

    describe "#create_branch" do
      it "creates a new branch through git" do
        Git.should_receive(:execute).with('git checkout -b branch_name')
        Git.create_branch("branch_name")
      end
    end

    describe "#commit" do
      it "creates an empty commit with the message" do
        Git.should_receive(:execute).with('git commit --allow-empty -m "my message"')
        Git.commit("my message")
      end
    end

    describe "#user_email" do
      it "looks up the user's email in the git config" do
        Git.should_receive(:execute).with('git config user.email')
        Git.user_email
      end
    end

    describe "#push_branch" do
      it "pushes the branch to origin" do
        Git.should_receive(:execute).with('git push origin branch_name')
        Git.push_branch("branch_name")
      end
    end

    describe "#origin_location" do
      it "runs show on the remote origin" do
        Git.should_receive(:execute).with('git remote show origin')
        Git.origin_location
      end

      SHOW = <<-END
* remote origin
  URL: git@github.com:rhburrows/reviewr.git
  Tracked remote branch
    master
      END

      it "parses out the URL" do
        Git.stub!(:execute).and_return(SHOW)
        Git.origin_location.should == "git@github.com:rhburrows/reviewr.git"
      end
    end

    describe "#origin_master_commit" do
      it "calls ls-remote on the origin master" do
        Git.should_receive(:execute).with('git ls-remote origin refs/heads/master')
        Git.origin_master_commit
      end

      it "returns only the sha" do
        Git.stub!(:execute).and_return("12345678123456781234567812345678        refs/heads/master")
        Git.origin_master_commit.should == "12345678123456781234567812345678"
      end
    end
  end
end
