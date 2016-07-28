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
      CompositeDatasetBuilder.build(file, MuiData, /MUI/, /Voltage/, /Current/, /Capacity/, /Run time/)
    end

  end

end; end; end
