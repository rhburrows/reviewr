require 'ruby-debug'

class Reviewr < Thor
  class CodeReview
    class << self
      def all
        Review.find_all(Reviewr.repo).map do |r|
          CodeReview.new(r.name, r.commit.id)
        end
      end

      def create_from_branch(branch, branch_name, index = nil)
        to = Reviewr.repo.head.commit
        from = Reviewr.repo.get_head(branch).commit.id
        index = index || Grit::Index.new(Reviewr.repo)
        sha = index.write_blob("#{from}\n#{to}")
        name = branch_name.nil? ? "review_#{sha.slice(0,8)}" : branch_name

        CodeReview.new(name, sha, index)
      end
    end

    attr_reader :name, :sha, :index

    def initialize(name, sha, index = nil)
      @name, @sha = name, sha
      @index = index || Grit::Index.new(Reviewr.repo)
    end

    def commit
      File.open("#{Reviewr.ref_dir}/#{name}", 'w') do |f|
        f.write(sha)
      end
      index.write_tree(index.tree)
    end

    def from
      blob_data.split("\n")[0]
    end

    def to
      blob_data.split("\n")[1]
    end

    def blob_data
      Reviewr.repo.blob(sha).data
    end

    class Review < Grit::Ref
    end
  end
end
