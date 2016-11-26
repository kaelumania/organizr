module Organizr
  class Scan
    def self.call(dir)
      new.call(dir)
    end

    def call(dir)
      raise "#{dir} is not a directory" unless File.directory?(dir)

      Enumerator.new do |yielder|
        walk(dir) do |file|
          yielder << file
        end
      end
    end

    private 

    def walk(dir, &block)
      Dir.foreach(dir) do |x|
        path = File.join(dir, x)
        if x == "." or x == ".."
          next
        elsif File.directory?(path)
          walk(path, &block)
        else
          block.call(File.new(path))
        end
      end
    end
  end
end
