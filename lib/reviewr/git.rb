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

    def rebase(base, branch)
      conflict = execute("git rebase #{base} #{branch}").to_s.
        include?("CONFLICT")
      if conflict
        execute('git rebase --abort')
      end
      !conflict
    end

    def create_branch(branch_name, base)
      execute("git branch #{branch_name} #{base}")
    end

    def commit(msg)
      execute("git commit --allow-empty -m \"#{msg}\"")
    end

    def current_branch
      m = execute("git branch").match(/^\* +(\w+)$/)
      m && m[1]
    end

    def change_branch(branch_name)
      execute("git checkout #{branch_name}")
    end

    def fetch(branch_name)
      execute("git fetch #{remote_repo} #{branch_name}")
    end

    def user_email
      email = execute('git config user.email')
      email && email.chomp
    end

    def push_branch(branch_name)
      execute("git push #{remote_repo} #{branch_name}")
    end

    def origin_location
      r = execute("git remote show #{remote_repo}")
      r && r.match(/URL: (.+)$/)[1]
    end

    def origin_master_commit
      r = execute("git ls-remote #{remote_repo} refs/heads/master")
      r && r.split(/\s+/)[0]
    end

    def cherry(from, to)
      execute("git cherry #{from} #{to}")
    end

    def cherry_pick(commit)
      execute("git cherry-pick #{commit}")
    end

    def execute(cmd)
      `#{cmd}`
    end
  end
end
