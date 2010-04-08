require 'spec_helper'

module Reviewr
  describe Mailer do
    describe "#send" do
      it "calls Pony#mail with the information from the project" do
        project = double("Project", :from => 'from', :to => 'to')
        Pony.should_receive(:mail).with(hash_including(:from => 'from',
                                                       :to => 'to',
                                                       :body => 'body'))
        Mailer.new(project).send('body')
      end
    end
  end
end
