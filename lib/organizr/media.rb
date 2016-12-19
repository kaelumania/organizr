module Organizr
  class Media
    attr_reader :path
    def initialize(path)
      @path = path
    end

    def file
      File.new(path)
    end

    def time
      # TODO check modified vs creation time
      exif_time || modified_time || created_time
    end

    def exif_time
      ext = File.extname(path).downcase
      if %w[.jpg .jpeg].include? ext
        return EXIFR::JPEG.new(path).date_time 
      end

      if %w[.tif].include? ext
        return EXIFR::TIFF.new(path).date_time
      end

      nil
    rescue StandardError => e
      nil
    end

    def creation_time
      file.birthtime
    end

    def modified_time
      file.mtime
    end

    def name
      File.basename(path)
    end
  end
end
