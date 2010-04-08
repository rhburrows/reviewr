class Input
  def initialize
    # default to entering nothing for each step
    @messages = (0..2).map{ '' }
  end

  def email=(email)
    @messages[0] = email
  end

  def password=(password)
    @messages[1] = password
  end

  def email_server=(server)
    @messages[2] = server
  end

  def gets
    @messages.shift
  end
end

def input
  @input ||= Input.new
end

class Output
  def messages
    @messages ||= []
  end

  def puts(message)
    messages << message
  end
end

def output
  @output ||= Output.new
end
