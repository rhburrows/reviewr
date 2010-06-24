require 'thor'
require 'grit'
require 'reviewr/code_review'

class Reviewr < Thor
  class << self
    attr_writer :repo

    def repo
      @repo ||= Grit::Repo.new('.')
    end

    def ref_dir
      dir = "#{repo.path}/reviews"
      unless File.exists?(dir)
        FileUtils.mkdir_p(dir)
      end
      dir
    end
  end

  desc "request BRANCH_NAME", "Request a code review compared to BRANCH_NAME"
  def request(branch)
    CodeReview.create_from_branch(branch).commit
  end
end
