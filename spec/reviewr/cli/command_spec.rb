require 'spec_helper'

module Reviewr
  module CLI
    describe Command do
      let(:project){ double("Project").as_null_object }
      let(:input){ double("Input").as_null_object }
      let(:output){ double("Output").as_null_object }
      let(:command){ Command.new(project, input, output) }

      describe "#prompt_for_user" do
        before do
          Termios.stub(:tcgetattr).and_return(mock("Attr").as_null_object)
          Termios.stub(:tcsetattr)
        end

        it "Asks for the user's email with the default user email from git" do
          command.project.stub(:user_email).and_return('e@s.com')
          output.should_receive(:print).with("Email (default e@s.com): ")
          command.prompt_for_user
        end

        it "Sets the entered email into the project" do
          command.project.should_receive(:user_email=).with("myemail@site.com")
          input.stub(:gets).and_return("myemail@site.com")
          command.prompt_for_user
        end

        it "Uses the default email if an empty string is entered" do
          command.project.should_not_receive(:user_email=)
          input.stub(:gets).and_return("\n")
          command.prompt_for_user
        end

        it "Asks for the user's email password" do
          output.should_receive(:print).with("Email password: ")
          command.prompt_for_user
        end

        it "Sets the entered email password into the project" do
          command.project.should_receive(:email_password=).with("asdf")
          input.stub(:gets).and_return("email@s.com", "asdf")
          command.prompt_for_user
        end

        it "Asks for the remote repository name" do
          output.should_receive(:print).
            with("Remote repository (default origin): ")
          command.prompt_for_user
        end

        it "Sets the entered remote repository into the project" do
          command.project.should_receive(:remote_repo=).with("remote_name")
          input.stub(:gets).and_return("remote_name\n")
          command.prompt_for_user
        end

        it "Uses the default remote repository if an empty string is entered" do
          command.project.should_not_receive(:remote_repo=)
          input.stub(:gets).and_return("\n")
          command.prompt_for_user
        end
      end
    end
  end
end
