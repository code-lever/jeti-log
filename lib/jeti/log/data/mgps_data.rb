module Jeti; module Log; module Data

  class MGPSData

    attr_reader :time
    attr_reader :stamp
    attr_reader :latitude
    attr_reader :longitude
    attr_reader :quality
    attr_reader :satellite_count
    attr_reader :distance
    attr_reader :speed
    attr_reader :course
    attr_reader :azimuth
    attr_reader :impulse
    attr_reader :date

    def initialize(time, fields)
      raise ArgumentError unless fields.length == 14
      @time = time
      @stamp, @latitude, @longitude, @quality, @satellite_count, @altitude,
          @distance, @speed, @relative_altitude, @course, @azimuth, @impulse,
          @trip, @date = fields
    end

    # Gets the altitude, in desired unit.
    #
    # @param unit one of :feet, :meters to define desired unit
    # @return [Float] altitude in the desired unit
    def altitude(unit = :meters)
      convert_length(@altitude, unit)
    end

    # Gets the distance from point of origin, in desired unit.
    #
    # @param unit one of :feet, :meters to define desired unit
    # @return [Float] distance in the desired unit
    def distance(unit = :meters)
      convert_length(@distance, unit)
    end

    # Gets the relative altitude, in desired unit.
    #
    # @param unit one of :feet, :meters to define desired unit
    # @return [Float] relative altitude in the desired unit
    def relative_altitude(unit = :meters)
      convert_length(@relative_altitude, unit)
    end

    # Gets the ground speed, in desired unit.
    #
    # @param unit one of :mps (m/s), :mph (mi/hr) to define desired unit
    # @return [Float] ground speed in the desired unit
    def speed(unit = :mps)
      convert_speed(@speed, unit)
    end

    # Gets the traveled path length, in desired unit.
    #
    # @param unit one of :feet, :meters to define desired unit
    # @return [Float] trip in the desired unit
    def trip(unit = :meters)
      convert_length(@trip, unit)
    end

    private

    def convert_length(value_in_meters, unit)
      case unit
      when :feet
        value_in_meters * 0.32808399
      else
        value_in_meters
      end
    end

    def convert_speed(value_in_meters_per_second, unit)
      case unit
      when :mph
        value_in_meters_per_second * 2.23694
      else
        value_in_meters_per_second
      end
    end

  end

  class MGPSDataBuilder

    def self.build(file)
      CompositeDatasetBuilder.build(file, MGPSData, /MGPS/, /Timestamp/i, /Latitude/,
                                    /Longitude/, /Quality/, /SatCount/, /Altitude/,
                                    /Distance/, /Speed/, /AltRelat/, /Course/, /Azimuth/,
                                    /Impulse/, /Trip/, /Date/)
    end

  end

end; end; end
