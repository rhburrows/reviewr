require 'pony'

module Reviewr
  class Mailer
    def initialize(project)
      @project = project
    end

    def send(body)
      Pony.mail(:from => @project.user_email,
                :to   => @project.to,
                :body => body,
                :subject => "Code review request from #{@project.user_email}",
                :via  => :smtp,
                :smtp => {
                  :host     => 'smtp.gmail.com',
                  :port     => '587',
                  :user     => @project.user_email,
                  :tls      => true,
                  :password => @project.email_password,
                  :auth     => :plain,
                  :domain   => @project.email_server
                })
    end
  end
end
