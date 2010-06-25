require 'spec_helper'

describe Reviewr do
  describe ".repo" do
    let(:mock_repo){ mock("Repository") }

    it "returns the repository if its been set" do
      Reviewr.repo = mock_repo
      Reviewr.repo.should == mock_repo
    end

    it "Creates a new repository if its not been set" do
      Reviewr.repo = nil
      Grit::Repo.should_receive(:new).with('.').and_return(mock_repo)
      Reviewr.repo.should == mock_repo
    end
  end

  describe ".ref_dir" do
    it "adds '/refs/reviews' to the repo's path" do
      Reviewr.repo = mock("Repo", :path => "path")
      Reviewr.ref_dir.should == "path/reviews"
    end

    it "creates the directory if it doesn't exist" do
      Reviewr.repo = mock("Repo", :path => '.git')
      FileUtils.rmdir('.git/reviews') if File.exists?('.git/reviews')
      Reviewr.ref_dir
      File.exists?('.git/reviews').should be_true
    end
  end

  describe "#request" do
    before do
      @review = mock("Code Review", :commit => true)
      Reviewr::CodeReview.stub(:create_from_branch).and_return(@review)
    end

    it "creates a code review request with the branch name" do
      Reviewr::CodeReview.should_receive(:create_from_branch).
        with('branch', nil)
      Reviewr.new.request('branch')
    end

    it "commits the code review request" do
      @review.should_receive(:commit)
      Reviewr.new.request("branch")
    end

    it "passes the branch name if it isn't empty" do
      reviewr = Reviewr.new([], { :name => 'my-branch-name' })
      Reviewr::CodeReview.should_receive(:create_from_branch).
        with('branch', 'my-branch-name')
      reviewr.request('branch')
    end
  end
end
