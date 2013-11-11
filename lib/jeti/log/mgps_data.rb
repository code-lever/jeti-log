module Jeti; module Log;

  class MGPSDataBuilder

    def self.build(file)
      lats = file.value_dataset(/MGPS/, /Latitude/)
      lons = file.value_dataset(/MGPS/, /Longitude/)
      alts = file.value_dataset(/MGPS/, /Altitude/)
      crss = file.value_dataset(/MGPS/, /Course/)
      qual = file.value_dataset(/MGPS/, /Quality/)
      sats = file.value_dataset(/MGPS/, /SatCount/)
      dsts = file.value_dataset(/MGPS/, /Distance/)
      spds = file.value_dataset(/MGPS/, /Speed/)
      rels = file.value_dataset(/MGPS/, /AltRelat/)
      azis = file.value_dataset(/MGPS/, /Azimuth/)

      lats.map do |raw_lat|
        time = raw_lat[0]
        lat = raw_lat[1]
        lon = lons.min_by { |lon| (lon[0] - time).abs }[1]
        alt = alts.min_by { |alt| (alt[0] - time).abs }[1]
        crs = crss.min_by { |crs| (crs[0] - time).abs }[1]
        MGPSData.new(time, lat, lon, alt, crs)
      end
    end

  end

  class MGPSData

    attr_reader :time, :latitude, :longitude, :course

    def initialize(time, latitude, longitude, altitude, course)
      @time = time
      @latitude = latitude
      @longitude = longitude
      @altitude = altitude
      @course = course
    end

    # Gets the altitude, in desired unit.
    #
    # @param unit one of :feet, :meters to define desired unit
    # @return [Float] altitude in the desired unit
    def altitude(unit = :feet)
      case unit
      when :feet
        @altitude * 0.32808399
      else
        @altitude
      end
    end

  end

end; end
