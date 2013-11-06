module Jeti; module Log;

  class Entry

    attr_reader :id

    def initialize(time, id, details)
      @time = time
      @id = id
      @details = details.each_slice(4).group_by(&:first)
      #puts @id
      #puts @details
    end

    def time
      @time.to_i
    end

    def detail(sensor_id)
      @details[sensor_id][0]
    rescue
      nil
    end

    def value(sensor_id)
      raw = detail(sensor_id)
      case raw[1]
      when '1'
        raw[3].to_i
      when '9'
        format_gps(raw[2], raw[3])
      else
        nil
      end
    rescue
      nil
    end

    private

    def format_gps(dec, val)
      minute = (val & 0xFFFF) / 1000.0
      degrees = (val >> 16) & 0xFF
      degrees += (minute / 60.0)
      degrees * (((dec >> 1) & 1) == 1 ? -1 : 1)
    end

  end

end; end
