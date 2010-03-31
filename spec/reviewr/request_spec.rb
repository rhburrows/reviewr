require 'spec_helper'

module Reviewr
  describe Request do
    describe "#call" do
      it "creates a git branch named 'review_sha'" do
        Git.stub!(:last_commit).and_return("1234567812345678123456781234567812345678")
        Git.should_receive(:create_branch).with("review_12345678")
        Request.new("blah").call
      end
    end
  end
end
