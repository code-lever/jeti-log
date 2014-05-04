module Jeti; module Log; module Data

  class MuiData

    attr_reader :time
    attr_reader :voltage
    attr_reader :current
    attr_reader :capacity
    attr_reader :run_time

    def initialize(time, fields)
      raise ArgumentError unless fields.length == 4
      @time = time
      @voltage, @current, @capacity, @run_time = fields
    end

  end

  class MuiDataBuilder

    def self.build(file)
      div10 = ->(val) { val / 10.0 }
      CompositeDatasetBuilder.build(file, MuiData, /MUI/, [/Voltage/, div10],
                                    [/Current/, div10], /Capacity/, /Run time/)
    end

  end

end; end; end
