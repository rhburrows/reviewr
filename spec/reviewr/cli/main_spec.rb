require 'spec_helper'

module Reviewr::CLI
  describe Main do
    describe "#initialize" do
      context "-p is not specified" do
        it "takes the first argument as the command name" do
          main = Main.new(["a", "b"])
          main.command.should == "a"
        end

        it "takes the rest of the arguments as the arguments" do
          main = Main.new(["a", "b", "c"])
          main.arguments.should == ["b", "c"]
        end
      end

      context "-p is specified" do
        it "Creates a pretend Git" do
          input = mock("input")
          output = mock("output")
          Reviewr::PretendGit.should_receive(:new).with(output)
          Main.new(["-p", "a", "b"], input, output)
        end

        it "Sets the pretend Git as the instance" do
          pretend_git = mock("Pretend Git")
          Reviewr::PretendGit.stub(:new).and_return(pretend_git)
          Main.new(["-p"])
          Reviewr::Git.instance.should == pretend_git
        end

        it "takes the second argument as the command name" do
          main = Main.new(["-p", "a", "b"])
          main.command.should == "a"
        end

        it "takes the rest of the arguments as the arguments" do
          main = Main.new(["-p", "a", "b"])
          main.arguments.should == ["b"]
        end
      end
    end

    describe "#run" do
      let(:main) { Main.new(['a']) }
      let(:command) { mock('Command').as_null_object }

      before do
        main.stub(:build_command).and_return(command)
      end

      it "builds a command object" do
        main.should_receive(:build_command)
        main.run
      end

      it "calls the command" do
        command.should_receive(:call)
        main.run
      end
    end

    describe "#build_command" do
      context "command name is 'request'"do
        let(:main) { Main.new(['request']) }

        before do
          @request = double("Request").as_null_object
          Request.stub(:new).and_return(@request)
        end

        it "creates a Reviewr::CLI::Request" do
          Request.should_receive(:new)
          main.build_command
        end

        it "passes the arguments to the request's arguments=" do
          @request.should_receive(:arguments=).with([1,2])
          main.stub(:arguments).and_return([1,2])
          main.build_command
        end
      end

      context "command name is 'accept'" do
        let(:main) { Main.new(['accept']) }

        before do
          @accept = double("Accept").as_null_object
          Accept.stub(:new).and_return(@accept)
        end

        it "creates a Reviewr::CLI::Accept" do
          Accept.should_receive(:new)
          main.build_command
        end
      end

      context "when passed a non-existant command" do
        let(:main) { Main.new(['blah']) }

        before do
          @help = double("help").as_null_object
          Help.stub(:new).and_return(@help)
        end

        it "creates a help command" do
          Help.should_receive(:new)
          main.build_command
        end
      end
    end
  end
end
