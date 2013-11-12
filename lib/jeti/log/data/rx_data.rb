module Jeti; module Log; module Data;

  class RxData

    attr_reader :voltage
    attr_reader :antenna1
    attr_reader :antenna2
    attr_reader :quality

    def initialize(time, fields)
      raise ArgumentError unless fields.length == 4
      @time = time
      @voltage, @antenna1, @antenna2, @quality = fields
    end

  end

  class RxDataBuilder

    def self.build(file)
      div100 = ->(val) { val / 100.0 }
      CompositeDatasetBuilder.build(file, RxData, /Rx/, [/U Rx/, div100], /A1/, /A2/, /Q/)
    end

  end

end; end; end
