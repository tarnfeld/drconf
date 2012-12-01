require "git"

module DrConf
  class Repo

    def self.find
      path = Pathname.new(DrConf::REPO_PATH).to_s
      repo_paths = []

      Dir.entries(path).select do |entry|
        if !(entry == '.' || entry == '..')
          repo_paths.push File.join(path, entry)
        end
      end

      repo_paths.map { |path|
        self.new(File.basename(path))
      }
    end

    attr_reader :name
    attr_reader :exists
    alias_method :exists?, :exists

    def initialize name
      @name = name

      @path = Pathname.new(DrConf::REPO_PATH)
      @path += @name

      begin
        @git_repo = Git.open @path
        @exists = true
      rescue ArgumentError => e
        @exists = false
      end
    end

    def init repo = nil
      if @exists
        raise "Repository at that path already exists, cannot clone"
      elsif repo
        @git_repo = Git.clone repo, @path.to_s
      else
        @git_repo = Git.init @path.to_s
      end
    end

    def switch ref
      if !@git_repo
        raise "Cannot switch a repo not backed by git"
      end

      @git_repo.checkout(ref)
    end
  end
end
