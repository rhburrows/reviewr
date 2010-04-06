require 'spec_helper'

module Reviewr
  describe Configuration do
    let(:git){ double("Git", :user_email => "email") }
    let(:config){ Configuration.new("to@site.com", git) }

    describe "#review_sha" do
      it "returns the first 8 characters of the last commit" do
        git.stub!(:last_commit).and_return('12345678123e324')
        config.review_sha.should == '12345678'
      end
    end

    describe "#master_sha" do
      it "returns the first 8 characters of the origin master commit" do
        git.stub!(:origin_master_commit).and_return('876543213672482637we7682')
        config.master_sha.should == '87654321'
      end
    end

    describe "#review_branch" do
      it "appends the review_sha to 'review_'" do
        config.stub!(:review_sha).and_return('12345678')
        config.review_branch.should == 'review_12345678'
      end
    end
  end
end
