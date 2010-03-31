require 'spec_helper'

describe Reviewr do
  describe "#run" do
    context "when passed 'request [opts]'"do
      before do
        @request = mock("Request").as_null_object
        Reviewr::Request.stub!(:new).and_return(@request)
      end

      it "creates a Reviewr::Request with the opts" do
        Reviewr::Request.should_receive(:new).with(["test@site.com"])
        Reviewr.run(["request", "test@site.com"])
      end

      it "calls #call on the request" do
        @request.should_receive(:call)
        Reviewr.run(["request"])
      end
    end

    context "when passed a non-existant command" do
      before do
        @help = mock("Help").as_null_object
        Reviewr::Help.stub!(:new).and_return(@help)
      end

      it "creates a help command" do
        Reviewr::Help.should_receive(:new)
        Reviewr.run(["asdf"])
      end

      it "calls #call on the help command" do
        @help.should_receive(:call)
        Reviewr.run(["ff"])
      end
    end
  end
end
