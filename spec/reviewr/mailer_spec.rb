require 'spec_helper'

module Reviewr
  describe Mailer do
    describe "#send" do
      let(:mailer){ Mailer.new(double("Project").as_null_object) }

      before do
        Pony.stub(:mail)
      end

      it "calls Pony#mail with the information from the project" do
        mailer.project.stub(:user_email).and_return('from')
        mailer.project.stub(:to).and_return('to')
        mailer.project.stub(:email_server).and_return('host')
        mailer.project.stub(:email_password).and_return('p')
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
        mailer.send('body')
      end

      context "successful sending" do
        it "returns true" do
          mailer.send('body').should be_true
        end
      end

      context "unsuccessful sending" do
        it "returns false" do
          $stderr.stub(:puts)
          Pony.stub(:mail).and_raise("Error sending")
          mailer.send('body').should be_false
        end
      end
    end
  end
end
