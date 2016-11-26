module Organizr
  class Copy
    # TODO parallel copy
    # https://github.com/grosser/parallel
    # https://github.com/chadrem/workers
    #
    def self.call(src, dst)
      new.call(src, dst)
    end

    attr_reader :verbose, :noop, :force
    def initialize(options)
      @verbose = options.fetch(:verbose) { false }
      @noop = options.fetch(:noop) { false }
      @force = options.fetch(:force) { false }
    end

    def call(src, dst)
      puts "Copy #{src} to #{dst}" if verbose || noop
      return if noop

      FileUtils.mkdir_p(File.dirname(dst))

      if File.exists?(dst) && !force
        raise "Destination file already exists #{dst}"
      end
      FileUtils.cp(src, dst, preserve: true)
    end
  end
end
