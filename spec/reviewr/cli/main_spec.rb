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

        it "creates a Reviewr::Request" do
          Request.should_receive(:new)
          main.build_command
        end
      end

      context "when passed a non-existant command" do
        let(:main) { Main.new(['blah']) }

        it "creates a help command" do
          Help.should_receive(:new)
          main.build_command
        end
      end
    end
  end
end
