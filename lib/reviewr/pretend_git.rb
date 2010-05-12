module Reviewr
  class PretendGit < Git
    attr_reader :output

    def initialize(output)
      @output = output
    end

    def rebase(base, branch)
      pretend_execute("git rebase #{base} #{branch}")
      true
    end

    def create_branch(branch_name, base)
      pretend_execute("git branch #{branch_name} #{base}")
    end

    def commit(msg)
      pretend_execute("git commit --allow-empty -m \"#{msg}\"")
    end

    def change_branch(branch_name)
      pretend_execute("git checkout #{branch_name}")
    end

    def fetch(branch_name)
      pretend_execute("git fetch #{remote_repo} #{branch_name}")
    end

    def push_branch(branch_name)
      pretend_execute("git push #{remote_repo} #{branch_name}")
    end

    def cherry_pick(commit)
      pretend_execute("git cherry-pick -s #{commit}")
    end

    def execute(cmd)
      output.puts(cmd)
      super(cmd)
    end

    def pretend_execute(cmd)
      output.puts(cmd)
    end
  end
end
