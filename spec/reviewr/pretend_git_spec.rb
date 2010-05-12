require 'spec_helper'

module Reviewr
  describe PretendGit do
    let(:output){ mock("Output").as_null_object }
    let(:p_git){ PretendGit.new(output) }

    describe "#rebase" do
      it "pretends to rebase" do
        output.should_receive(:puts).with('git rebase base branch')
        p_git.rebase('base', 'branch')
      end

      it "returns true" do
        p_git.rebase('base', 'branch').should be_true
      end
    end

    describe "#create_branch" do
      it "pretends to create a branch" do
        output.should_receive(:puts).with("git branch name base")
        p_git.create_branch('name', 'base')
      end
    end

    describe "#commit" do
      it "pretends to commit" do
        output.should_receive(:puts).with("git commit --allow-empty -m \"msg\"")
        p_git.commit("msg")
      end
    end

    describe "#change_branch" do
      it "pretends to change branches" do
        output.should_receive(:puts).with("git checkout branch")
        p_git.change_branch('branch')
      end
    end

    describe "#fetch" do
      it "pretends to fetch" do
        output.should_receive(:puts).with("git fetch repo branch")
        p_git.remote_repo = 'repo'
        p_git.fetch('branch')
      end
    end

    describe "#push_branch" do
      it "pretends to push the branch" do
        output.should_receive(:puts).with("git push repo branch")
        p_git.remote_repo = 'repo'
        p_git.push_branch('branch')
      end
    end

    describe "#cherry_pick" do
      it "pretends to cherry pick" do
        output.should_receive(:puts).with("git cherry-pick -s 12345678")
        p_git.cherry_pick('12345678')
      end
    end
  end
end
