module Jeti; module Log; module Data;

  class MGPSData

    attr_reader :time
    attr_reader :latitude
    attr_reader :longitude
    attr_reader :course

    def initialize(time, fields)
      raise ArgumentError unless fields.length == 4
      @time = time
      @latitude, @longitude, @altitude, @course = fields
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

  class MGPSDataBuilder

    def self.build(file)
      CompositeDatasetBuilder.build(file, MGPSData, /MGPS/, /Latitude/,
                                    /Longitude/, /Altitude/, /Course/)
    end

  end

end; end; end
