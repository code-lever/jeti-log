module Jeti; module Log;

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

    def initialize(time, vbatt, ibatt, vbec, ibec, mah, rpm, temp, runtime, pwm)
      @time = time
      @battery_voltage = vbatt
      @battery_current = ibatt
      @bec_voltage = vbec
      @bec_current = ibec
      @capacity = mah
      @rpm = rpm
      @temperature = temp
      @run_time = runtime
      @pwm = pwm
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

end; end
