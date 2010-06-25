require 'spec_helper'

describe Reviewr::CodeReview do
  describe ".find_all" do
    it "looks up all the review refs" do
      repo = mock("Repository")
      Reviewr.repo = repo
      Reviewr::CodeReview::Review.should_receive(:find_all).with(repo).
        and_return([])
      Reviewr::CodeReview.all
    end

    it "returns a list of code reviews - one per ref" do
      refs = [mock("Ref 1", :name => 'one', :commit => mock('1',:id => '1234')),
              mock("Ref 2", :name => 'two', :commit => mock('2',:id => '4321'))]
      Reviewr::CodeReview::Review.stub(:find_all).and_return(refs)
      Reviewr::CodeReview.all.map{ |c| [c.name, c.sha] }.should ==
        [ ['one', '1234'], ['two', '4321'] ]
    end
  end

  describe "#create_from_branch" do
    before do
      # This is a lot of bad mocking...
      branch = mock("branch head",
                    :name => "branch",
                    :commit => mock("c1", :id => "123456789"))
      head = mock("current head",
                  :name => "current",
                  :commit => "987654321")
      Reviewr.repo.stub(:get_head).and_return(branch)
      Reviewr.repo.stub(:head).and_return(head)
    end

    it "writes a blob with both commits to the index" do
      index = mock("Index")
      index.should_receive(:write_blob).with("123456789\n987654321").
        and_return('')
      Reviewr::CodeReview.create_from_branch('branch', nil, index)
    end

    it "returns a new code review object with the written index" do
      index = mock("Index", :write_blob => '')
      review = Reviewr::CodeReview.create_from_branch('branch', nil, index)
      review.index.should == index
    end

    it "returns a new code review object with the sha of the blob" do
      index = mock("Index", :write_blob => '555f')
      review = Reviewr::CodeReview.create_from_branch('branch', nil, index)
      review.sha.should == '555f'
    end

    it "returns a new code review object with the name review_<blobsha>" do
      index = mock("Index", :write_blob => '555f')
      review = Reviewr::CodeReview.create_from_branch('branch', nil, index)
      review.name.should == 'review_555f'
    end

    it "sets the code review name to the value passed if it is supplied" do
      index = mock("Index", :write_blob => '555f')
      review = Reviewr::CodeReview.create_from_branch('branch', 'branch', index)
      review.name.should == 'branch'
    end
  end

  describe "#commit" do
    let(:index) { mock("Index", :write_tree => true, :tree => @tree) }
    let(:review) { Reviewr::CodeReview.new('review_name', '1234', index) }

    before do
      Reviewr.stub(:ref_dir).and_return('.git/refs/reviews')
    end

    it "creates a file with the review name" do
      review.commit
      File.exists?(".git/refs/reviews/review_name").should be_true
    end

    it "writes the review sha to the file" do
      review.commit
      File.read(".git/refs/reviews/review_name").should == '1234'
    end

    it "commits the index" do
      @tree = mock("Tree")
      review.index.should_receive(:write_tree).with(@tree)
      review.commit
    end
  end

  describe "#from" do
    it "returns the first line of the blob data" do
      review = Reviewr::CodeReview.new('test', '12345')
      review.stub(:blob_data).and_return("one\ntwo")
      review.from.should == "one"
    end
  end

  describe "#to" do
    it "returns the second line of the blob data" do
      review = Reviewr::CodeReview.new('test', '12345')
      review.stub(:blob_data).and_return("one\ntwo")
      review.to.should == "two"
    end
  end

  describe "#blob_data" do
    it "gets the blob data from the repository" do
      review = Reviewr::CodeReview.new('test', '12345')
      blob = mock('Blob', :data => 'data')
      Reviewr.repo.should_receive(:blob).with('12345').and_return(blob)
      review.blob_data.should == 'data'
    end
  end
end
