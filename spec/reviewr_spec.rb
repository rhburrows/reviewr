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
        Reviewr.run("request test@site.com")
      end

      it "calls execute on the request" do
        @request.should_receive(:call)
        Reviewr.run("request")
      end
    end
  end
end
