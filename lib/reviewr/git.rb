module Reviewr
  class Git
    class << self
      def instance
        @instance ||= Git.new
      end

      def instance=(instance)
        @instance = instance
      end
    end

    attr_writer :remote_repo

    def remote_repo
      @remote_repo ||= "origin"
    end

    def last_commit
      execute('git show --pretty=format:"%H" HEAD').split("\n")[0]
    end

    def create_branch(branch_name)
      execute("git checkout -b #{branch_name}")
    end

    def commit(msg)
      execute("git commit --allow-empty -m \"#{msg}\"")
    end

    def user_email
      email = execute('git config user.email')
      email && email.chomp
    end

    def push_branch(branch_name)
      execute("git push origin #{branch_name}")
    end

    def origin_location
      r = execute("git remote show #{remote_repo}")
      r && r.match(/URL: (.+)$/)[1]
    end

    def origin_master_commit
      r = execute("git ls-remote origin refs/heads/master")
      r && r.split(/\s+/)[0]
    end

    def execute(cmd)
      `#{cmd}`
    end
  end
end
