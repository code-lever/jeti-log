module Jeti; module Log; module Data

  class MezonData

    attr_reader :time
    attr_reader :battery_voltage
    attr_reader :battery_current
    attr_reader :bec_voltage
    attr_reader :bec_current
    attr_reader :capacity
    attr_reader :rpm
    attr_reader :run_time
    attr_reader :pwm

    def initialize(time, fields)
      raise ArgumentError unless fields.length == 9
      @time = time
      @battery_voltage, @battery_current, @bec_voltage, @bec_current, @capacity,
        @rpm, @temperature, @run_time, @pwm = fields
    end

    def temperature(unit = :c)
      case unit
      when :f
        (@temperature * (9.0 / 5.0)) + 32
      else
        @temperature
      end
    end

  end

  class MezonDataBuilder

    def self.build(file)
      CompositeDatasetBuilder.build(file, MezonData, /Mezon/i, /U Battery/, /I Battery/,
        /U BEC/, /I BEC/, /Capacity/, /Revolution/, /Temp/, /Run Time/, /PWM/)
    end

  end

end; end; end
