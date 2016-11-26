require "organizr/version"
require "organizr/media"
require "organizr/scan"
require "organizr/copy"

module Organizr
  def self.call(from, to)
    Runner.new.call(from, to)
  end

  class Runner
    attr_reader :copy, :scan

    def initialize(scan: Scan, copy: Copy)
      @copy, @scan = copy, scan
    end

    def call(from, to)
      scan.(from)
        .map {|file| Media.new(file) }
        .each {|media| copy.(media.path, dst(to, media)) }
    end

    private

    def dst(to, media)
      year = media.time.strftime '%Y'
      month = media.time.strftime '%m %b'

      File.join(to, File.join(year, month, media.name))
    end
  end
end
