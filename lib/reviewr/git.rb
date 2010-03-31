module Reviewr
  class Git
    class << self
      def last_commit
        execute('git show --pretty=format:"%H" HEAD').split("\n")[0]
      end

      def create_branch(branch_name)
        execute("git co -b #{branch_name}")
      end

      def instance
        @instance ||= Git.new
      end

      def instance=(instance)
        @instance = instance
      end

      def execute(cmd)
        instance.execute(cmd)
      end
    end

    def execute(cmd)
      `#{cmd}`
    end
  end
end
