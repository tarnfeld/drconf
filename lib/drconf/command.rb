require "clamp"

module DrConf
  module Command

    # "init"
    class InitCommand < Clamp::Command
      parameter "NAME", "Friendly name for the repo, no spaces please."
      option "--remote", "REMOTE_REPO", "Remote git repository to clone"
      option "--branch", "REPO_BRANCH", "Optionally check the repository out to a branch"

      def execute
        repo = Repo.new name

        if repo.exists?
          raise "It already exists, idiot"
        else
          repo.init remote

          if branch
            repo.switch branch
          end
        end
      end
    end

    # "list"
    class ListCommand < Clamp::Command

      def execute
        repos = Repo.find
        if repos
          repos.each do |repo|
            puts repo.name
          end
        else
          raise "No repositories found, use init to create one"
        end
      end
    end

    # "sync"
    class SyncCommand < Clamp::Command

    end

    # Root command for drconf
    class RootCommand < Clamp::Command

      subcommand "init", "Initalize a new repo to store config files in, or clone one", InitCommand
      subcommand "list", "List all repos", ListCommand
      subcommand "sync", "Pull down the latest changes from a repo", SyncCommand
    end
  end
end
