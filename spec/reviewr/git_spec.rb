require 'spec_helper'

module Reviewr
  describe Git do
    let(:git) { Git.new }

    before do
      git.stub(:execute)
    end

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
        git.should_receive(:execute).with('git branch branch_name base')
        git.create_branch("branch_name", "base")
      end
    end

    describe "#rebase" do
      it "runs rebase through git" do
        git.should_receive(:execute).with('git rebase base branch')
        git.rebase('base', 'branch')
      end

      it "returns true if the rebase happens cleanly" do
        git.stub(:execute).and_return("")
        git.rebase('base', 'branch').should be_true
      end

      it "returns false if the rebase has a conflict" do
        git.stub(:execute).and_return("CONFLICT")
        git.rebase('base', 'branch').should_not be_true
      end

      it "aborts the rebase if there is a conflict" do
        git.stub(:execute).and_return("CONFLICT")
        git.should_receive(:execute).with('git rebase --abort')
        git.rebase('base', 'branch')
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

    describe "#fetch" do
      it "fetches the branch from the remote repository" do
        git.remote_repo = "remote"
        git.should_receive(:execute).with('git fetch remote branch_name')
        git.fetch('branch_name')
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
      it "pushes the branch to the remote repo" do
        git.remote_repo = "remote"
        git.should_receive(:execute).with('git push remote branch_name')
        git.push_branch("branch_name")
      end
    end

    describe "#origin_location" do
      it "runs show on the remote remote repo" do
        git.remote_repo = "remote"
        git.should_receive(:execute).with('git remote show remote')
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
      it "calls ls-remote on the remote master" do
        git.remote_repo = 'remote'
        git.should_receive(:execute).with('git ls-remote remote refs/heads/master')
        git.origin_master_commit
      end

      it "returns only the sha" do
        git.stub!(:execute).and_return("12345678123456781234567812345678        refs/heads/master")
        git.origin_master_commit.should == "12345678123456781234567812345678"
      end
    end

    describe "#cherry" do
      it "calls cherry between the passed branches" do
        git.should_receive(:execute).with('git cherry from to')
        git.cherry('from', 'to')
      end
    end

    describe "#cherry_pick" do
      it "calls cherry-pick with the passed commit" do
        git.should_receive(:execute).with('git cherry-pick commit')
        git.cherry_pick('commit')
      end
    end

    describe "#log" do
      it "calls log with n = the number passed" do
        git.should_receive(:execute).with('git log -n 1')
        git.log(1)
      end
    end
  end
end
