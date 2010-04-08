require 'spec_helper'

module Reviewr
  describe Mailer do
    describe "#send" do
      it "calls Pony#mail with the information from the project" do
        project = double("Project",
                         :user_email => 'from',
                         :to => 'to',
                         :email_server => 'host',
                         :email_password => 'p')
        Pony.should_receive(:mail).with(
          hash_including(:from => 'from',
                         :to   => 'to',
                         :body => 'body',
                         :subject => 'Code review request from from',
                         :via  => :smtp,
                         :smtp => {
                           :host     => 'smtp.gmail.com',
                           :port     => '587',
                           :user     => 'from',
                           :tls      => true,
                           :password => 'p',
                           :auth     => :plain,
                           :domain   => 'host'
                         }))
        Mailer.new(project).send('body')
      end
    end
  end
end
