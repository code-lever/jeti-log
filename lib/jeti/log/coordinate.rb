module Jeti; module Log;

  class Coordinate

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
