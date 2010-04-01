require 'spec_helper'

module Reviewr::CLI
  describe Main do
    describe "#initialize" do
      it "takes the first argument as the command name" do
        main = Main.new(["a", "b", "c"])
        main.command.should == "a"
      end

      it "considers the rest of the arguments the command arguments" do
        main = Main.new(['a', 'b', 'c'])
        main.args.should == ['b', 'c']
      end
    end

    describe "#run" do
      context "command name is 'request'"do
        before do
          @request = mock("Request").as_null_object
          Request.stub!(:new).and_return(@request)
        end

        it "creates a Reviewr::Request with the opts" do
          Request.should_receive(:new).with("test@site.com")
          Main.new(["request", "test@site.com"]).run
        end

        it "calls #call on the request" do
          @request.should_receive(:call)
          Main.new(["request"]).run
        end
      end

      context "when passed a non-existant command" do
        before do
          @help = mock("Help").as_null_object
          Help.stub!(:new).and_return(@help)
        end

        it "creates a help command" do
          Help.should_receive(:new)
          Main.new(["asdf"]).run
        end

        it "calls #call on the help command" do
          @help.should_receive(:call)
          Main.new(["ff"]).run
        end
      end
    end
  end
end
