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

  def remote_repo=(repo)
    @messages[2] = repo
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

  def print(message)
    messages << message
  end
end

def output
  @output ||= Output.new
end
