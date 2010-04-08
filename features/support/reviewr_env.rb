# Override a few methods in Termios
# These methods are just used for hiding the user's input when
# reviewr prompts them for a password, but I don't want to deal
# with this in cucumber so I manually stubbed out the methods
module Termios
  class << self
    def tcgetattr(a)
      FakeAttr.new
    end

    def tcsetattr(a, b, c)
    end
  end

  class FakeAttr
    def lflag
      1
    end

    def lflag=(v)
    end
  end
end

