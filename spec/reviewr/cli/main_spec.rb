require 'spec_helper'

module Reviewr::CLI
  describe Main do
    describe "#initialize" do
      it "takes the first argument as the command name" do
        main = Main.new(["a", "b"])
        main.command.should == "a"
      end

      it "initializes the project with the second argument" do
        Reviewr::Project.should_receive(:new).with("b")
        main = Main.new(["a", "b"])
      end
    end

    describe "#run" do
      context "command name is 'request'"do
        before do
          @request = mock("Request").as_null_object
          Request.stub!(:new).and_return(@request)
        end

        it "creates a Reviewr::Request" do
          Request.should_receive(:new)
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

    describe "#prompt_for_user" do
      let(:input){ double("Input").as_null_object }
      let(:output){ double("Output").as_null_object }
      let(:main) { Main.new(['a']) }

      it "Asks for the user's email with the default user email from git" do
        Reviewr::Git.instance.stub(:user_email).and_return('e@s.com')
        output.should_receive(:puts).with("Email (default e@s.com): ")
        main.prompt_for_user(input, output)
      end

      it "Sets the entered email into the project" do
        main.project.should_receive(:user_email=).with("myemail@site.com")
        input.stub(:gets).and_return("myemail@site.com")
        main.prompt_for_user(input, output)
      end

      it "Uses the default email if an empty string is entered" do
        main.project.should_not_receive(:user_email=)
        input.stub(:gets).and_return("\n")
        main.prompt_for_user(input, output)
      end

      it "Asks for the user's email password" do
        output.should_receive(:puts).with("Email password: ")
        main.prompt_for_user(input, output)
      end

      it "Sets the entered email password into the project" do
        main.project.should_receive(:email_password=).with("asdf")
        input.stub(:gets).and_return("email", "asdf")
        main.prompt_for_user(input, output)
      end
    end
  end
end
