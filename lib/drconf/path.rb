module DrConf
  class Path

    def initialize path
      @raw_path = path
      @path = Pathname.new(path)
    end

    def exists?
      File.exists? @raw_path
    end

    def to_s
      @raw_path
    end
  end
end
