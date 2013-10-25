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

    def detail(sensor_index)
      @details[sensor_index][0]
    end

  end

end; end
