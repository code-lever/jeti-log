module Jeti; module Log;

  class MezonDataBuilder

    def self.build(file)
      vbatts = file.value_dataset(/Mezon/i, /U Battery/, ->(val) { val / 10.0 })
      ibatts = file.value_dataset(/Mezon/i, /I Battery/)
      vbecs = file.value_dataset(/Mezon/i, /U BEC/, ->(val) { val / 10.0 })
      ibecs = file.value_dataset(/Mezon/i, /I BEC/)
      mahs = file.value_dataset(/Mezon/i, /Capacity/)
      rpms = file.value_dataset(/Mezon/i, /Revolution/)
      temps = file.value_dataset(/Mezon/i, /Temp/)
      times = file.value_dataset(/Mezon/i, /Run Time/)
      pwms = file.value_dataset(/Mezon/i, /PWM/)

      vbatts.map do |raw_vb|
        time = raw_vb[0]
        vbatt = raw_vb[1]
        ibatt = ibatts.min_by { |e| (e[0] - time).abs }[1]
        vbec = vbecs.min_by { |e| (e[0] - time).abs }[1]
        ibec = ibecs.min_by { |e| (e[0] - time).abs }[1]
        mah = mahs.min_by { |e| (e[0] - time).abs }[1]
        rpm = rpms.min_by { |e| (e[0] - time).abs }[1]
        temp = temps.min_by { |e| (e[0] - time).abs }[1]
        runtime = times.min_by { |e| (e[0] - time).abs }[1]
        pwm = pwms.min_by { |e| (e[0] - time).abs }[1]
        MezonData.new(time, vbatt, ibatt, vbec, ibec, mah, rpm, temp, runtime, pwm)
      end
    end

  end

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
