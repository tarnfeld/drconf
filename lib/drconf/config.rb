require 'drconf/constants'
require 'yaml'

module DrConf

  class Config

    def self.instance (file_path)
      @instances ||= {}
      if @instances.has_key?(file_path)
        return @instances[file_path]
      end

      @instances[file_path] = self.new(file_path)
    end

    def initialize (file_path)
      @path = Pathname.new(DrConf::ROOT_PATH)
      @path += file_path
    end

    def method_missing (method, *args, &block)
      self._load_config()

      puts @config
    end

    def _load_config
      if !@loaded && File.exists?(@path)
        @config = YAML::load(File.open(@path))
      end
    end
  end
end
