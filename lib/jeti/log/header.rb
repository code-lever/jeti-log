module Jeti; module Log

  class Header < Entry

    attr_reader :sensor_id, :name, :unit

    def initialize(time, id, details)
      super
      @sensor_id = details[0]
      @name = details[1]
      @unit = details[2]
    end

  end

end; end
