module Organizr
  class Media
    attr_reader :file
    def initialize(file)
      @file = file
    end

    def path
      file.path
    end

    def time
      # TODO check modified vs creation time
      exif_time || creation_time || modified_time
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
