module Organizr
  class Move
    def self.call(src, dst)
      new.call(src, dst)
    end

    attr_reader :verbose, :noop, :force, :ignore
    def initialize(options)
      @verbose = options.fetch(:verbose) { false }
      @noop = options.fetch(:noop) { false }
      @force = options.fetch(:force) { false }
      @ignore = options.fetch(:ignore) { false }
    end

    def call(src, dst)
      puts "Move #{src} to #{dst}" if verbose || noop
      return if noop

      FileUtils.mkdir_p(File.dirname(dst))

      if File.exists?(dst)
        if ignore
          puts "Ignore #{src}"
        elsif !force
          raise "Destination file already exists #{dst}"
        end
      end

      FileUtils.mv(src, dst, force: force, noop: noop, verbose: verbose)
    end
  end
end
