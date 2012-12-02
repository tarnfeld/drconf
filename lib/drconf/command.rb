require "clamp"
require "rainbow"
require "highline/import"

module DrConf
  module Command

    # "init"
    class InitCommand < Clamp::Command
      parameter "NAME", "Friendly name for the repository, no spaces please."
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
          puts "Found #{repos.length} repositories".foreground :green

          repos.each do |repo|
            puts ("- " + repo.to_s).foreground :cyan
          end
        else
          puts "No repositories found, use the `init` command to create one.".foreground :red
        end
      end
    end

    # "include"
    class IncludeCommand < Clamp::Command
      parameter "PATH", "Path to file or folder to include in the repo"
      parameter "REPO_NAME", "Repo to include the file in"

      def execute
        repo = Repo.new repo_name
        if repo.includes? path
          puts "The repo '#{repo_name}' already includes the path '#{path}'".foreground :red
        else
          repo.include path
        end
      end
    end

    # "watch"
    class WatchCommand < Clamp::Command

    end

    # "unwatch"
    class UnWatchCommand < Clamp::Command

    end

    # "sync"
    class SyncCommand < Clamp::Command

    end

    # "remove"
    class RemoveCommand < Clamp::Command
      parameter "REPO ...", "Name(s) of the repository to remove"

      def execute
        puts "Removing #{repo_list.length} repositories".foreground :green

        repo_list.map do |repo|
          repo = Repo.new repo
          if !repo.exists?
            puts "The repo '#{repo.name}' does not exist".foreground :red
          else
            remove = agree "Are you sure you want to delete #{repo}? [Y/n]"

            if remove
              repo.remove!
              puts "Successfully removed repo #{repo}".foreground :green
            end
          end
        end
      end
    end

    # Root command for drconf
    class RootCommand < Clamp::Command

      option ["--version", "-v"], :flag, "Show current version" do
        puts "DrConf #{DrConf::VERSION} #{DrConf::COPYRIGHT}"
        exit(0)
      end

      subcommand "init", "Initalize a new repository to store config files in, or clone one", InitCommand
      subcommand "list", "List all repositories", ListCommand
      subcommand "include", "Add a local file to a repository", IncludeCommand
      subcommand "watch", "Watch a file from a repository", WatchCommand
      subcommand "unwatch", "Remove a local file from the watch list", UnWatchCommand
      subcommand "sync", "Pull down the latest changes from a repository", SyncCommand
      subcommand "remove", "Remove a repository", RemoveCommand
    end
  end
end
