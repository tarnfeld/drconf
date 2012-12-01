module DrConf

  # Root directory to store various data files and cloned repos
  ROOT_PATH = File.expand_path("~/.drconf")

  # Path to store cloned repos (within ROOT_PATH)
  REPO_PATH = (Pathname.new(DrConf::ROOT_PATH) + "repos").to_s

  # Path to store the drconf config file (within ROOT_PATH)
  CONFIG_PATH = "config.yml"

end
