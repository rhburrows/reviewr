require 'pony'

module Reviewr
  class Mailer
    attr_reader :project

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
      true
    rescue => e
      $stderr.puts "Error sending email:"
      $stderr.puts e.inspect
      false
    end
  end
end
