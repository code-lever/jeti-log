module Jeti; module Log;

  class Entry

    attr_reader :id

    def initialize(time, id, details)
      @time = time
      @id = id
      @details = details.each_slice(4).group_by(&:first)
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
      when '1','4','8'
        raw[3].to_i
      when '5'
        min = (raw[3].to_i & 0xFF00) >> 8
        sec = (raw[3].to_i & 0x00FF)
        (min * 60) + sec
      when '9'
        format_gps(raw[2].to_i, raw[3].to_i)
      when '14'
        format_date(raw[3])
      else
        nil
      end
    rescue
      nil
    end

    private

    def format_date(val)
      month = (val & 0xFF00) >> 8
      day = val >> 16
      year = val & 0x00FF
      Date.new(year, month, day)
    end

    def format_gps(dec, val)
      minute = (val & 0xFFFF) / 1000.0
      degrees = (val >> 16) & 0xFF
      degrees += (minute / 60.0)
      degrees * (((dec >> 1) & 1) == 1 ? -1 : 1)
    end

  end

end; end
