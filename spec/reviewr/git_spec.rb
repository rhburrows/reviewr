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
        Git.should_receive(:execute).with('git co -b branch_name')
        Git.create_branch("branch_name")
      end
    end
  end
end
