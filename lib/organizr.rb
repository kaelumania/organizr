require "organizr/version"
require "organizr/media"
require "organizr/scan"
require "organizr/copy"
require "organizr/move"

require "yaml"

module Organizr
  def self.call(from, to)
    Runner.new.call(from, to)
  end

  YEAR_MONTH = ->(media) do
      year = media.time.strftime '%Y'
      month = media.time.strftime '%m %b'

      [year, month]
  end

  class Runner
    attr_reader :action, :scan, :categorize, :summary

    def initialize(scan: Scan, action: Move, categorize: YEAR_MONTH )
      @action, @scan, @categorize = action, scan, categorize
      @summary = Hash.new 0
    end

    def call(from, to)
      scan.(from)
        .map {|file| Media.new(file) }
        .map {|media| [media, categorize.call(media)] }
        .each {|media, category| summary[category.join('/')] += 1 }
        .each {|media, category| action.(media.path, File.join(to, File.join(category, media.name))) }

      puts summary.to_yaml
    end

    private

    def dst(to, media)
      File.join(to, File.join(*category(media), media.name))
    end
  end
end
