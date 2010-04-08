require 'spec_helper'

module Reviewr::CLI
  describe Main do
    before do
      Termios.stub(:tcgetattr).and_return(mock("Attr").as_null_object)
      Termios.stub(:tcsetattr)
    end

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
          new_main(["request", "test@site.com"]).run
        end

        it "calls #call on the request" do
          @request.should_receive(:call)
          new_main(["request"]).run
        end
      end

      context "when passed a non-existant command" do
        before do
          @help = mock("Help").as_null_object
          Help.stub!(:new).and_return(@help)
        end

        it "creates a help command" do
          Help.should_receive(:new)
          new_main(["asdf"]).run
        end

        it "calls #call on the help command" do
          @help.should_receive(:call)
          new_main(["ff"]).run
        end
      end

      def new_main(args)
        m = Main.new(args)
        m.stub(:prompt_for_user)
        m
      end
    end

    describe "#prompt_for_user" do
      let(:input){ double("Input").as_null_object }
      let(:output){ double("Output").as_null_object }
      let(:main) { Main.new(['a']) }

      it "Asks for the user's email with the default user email from git" do
        Reviewr::Git.instance.stub(:user_email).and_return('e@s.com')
        output.should_receive(:print).with("Email (default e@s.com): ")
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
        output.should_receive(:print).with("Email password: ")
        main.prompt_for_user(input, output)
      end

      it "Sets the entered email password into the project" do
        main.project.should_receive(:email_password=).with("asdf")
        input.stub(:gets).and_return("email@s.com", "asdf")
        main.prompt_for_user(input, output)
      end

      it "Asks for the remote repository name" do
        output.should_receive(:print).
               with("Remote repository (default origin): ")
        main.prompt_for_user(input, output)
      end

      it "Sets the entered remote repository into the project" do
        main.project.should_receive(:remote_repo=).with("remote_name")
        input.stub(:gets).and_return("remote_name\n")
        main.prompt_for_user(input, output)
      end

      it "Uses the default remote repository if an empty string is entered" do
        main.project.should_not_receive(:remote_repo=)
        input.stub(:gets).and_return("\n")
        main.prompt_for_user(input, output)
      end
    end
  end
end
