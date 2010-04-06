require 'pony'

module Reviewr
  class Mailer
    def initialize(configuration)
      @configuration = configuration
    end

    def send(body)
      Pony.mail(:from => @configuration.from,
                :to   => @configuration.to,
                :body => body)
    end
  end
end
