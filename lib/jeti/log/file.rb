require 'open-uri'

module Jeti; module Log;

  class File

    attr_reader :name

    # Determines if the file at the given URI is a Jeti telemetry log file.
    #
    # @param uri URI to file to read
    # @return [Jeti::Log::File] loaded file if the file is a Jeti log file, nil otherwise
    def self.jeti?(uri)
      File.new(uri) rescue nil
    end

    def initialize(uri)

      open(uri, 'rb') do |file|
        lines = file.readlines.map(&:strip).group_by do |line|
          line.start_with?('#') ? :comments : :rows
        end
        @name = lines.fetch(:comments, ['Unknown']).first

        @headers = []
        @entries = []
        lines[:rows].each_with_object(';').map(&:split).each do |line|
          if '000000000' == line.first
            if line.length == 4
              line << ''
            elsif line.length == 5
              # do nothing
            else
              raise RuntimeError, "Unexpected header length (#{line.length})"
            end
            @headers << Header.new(line[0], line[1], line[2..4])
          else
            @entries << Entry.new(line[0], line[1], line[2..-1])
          end
        end

        raise RuntimeError, 'No headers found in log file' if @headers.empty?
        raise RuntimeError, 'No entries found in log file' if @entries.empty?
      end

    rescue => e
      raise ArgumentError, "File does not appear to be a Jeti log (#{e})"
    end

    # Gets the duration of the session, in seconds.
    #
    # @return [Float] duration of the session, in seconds
    def duration
      (@entries.last.time - @entries.first.time) / 1000.0
    end

    def antenna1_signals?
      !antenna1_signals.empty?
    end

    def antenna1_signals
      @antenna1_signals ||= build_value_dataset('Rx', 'A1')
    end

    def antenna2_signals?
      !antenna2_signals.empty?
    end

    def antenna2_signals
      @antenna2_signals ||= build_value_dataset('Rx', 'A2')
    end

    def rx_voltages?
      !rx_voltages.empty?
    end

    def rx_voltages
      @rx_voltages ||= build_rx_voltages
    end

    def signal_qualities?
      !signal_qualities.empty?
    end

    def signal_qualities
      @signal_qualities ||= build_value_dataset('Rx', "Q")
    end

    def mgps_locations?
      device_present?('MGPS')
    end

    def mgps_locations
     @mgps_locations ||= build_mgps_locations
    end

    private

    def build_mgps_locations
      lats = build_value_dataset('MGPS', 'Latitude')
      lons = build_value_dataset('MGPS', 'Longitude')
      alts = build_value_dataset('MGPS', 'Altitude')
      crss = build_value_dataset('MGPS', 'Course')

      coords = lats.map { |l| [l[0], { latitude: l[1] }] }
      coords.map do |c|
        [
          c[0],
          {
            longitude: lons.min_by { |lon| (lon[0] - c[0]).abs }[1],
            altitude:  alts.min_by { |alt| (alt[0] - c[0]).abs }[1],
            course:    crss.min_by { |crs| (crs[0] - c[0]).abs }[1]
          }.merge(c[1])
        ]
      end
    end

    def build_rx_voltages
      build_value_dataset('Rx', 'U Rx', ->(val) { val / 100.0 })
    end

    def build_value_dataset(device, sensor, modifier = ->(val) { val })
      headers, entries = headers_and_entries_by_device(device)
      sensor_id = (headers.select { |h| h.name == sensor })[0].sensor_id
      entries.reject! { |e| e.detail(sensor_id).nil? }
      entries.map { |e| [e.time, modifier.call(e.value(sensor_id))] }
    end

    def headers_and_entries_by_device(device)
      headers = @headers.select { |h| h.name == device }
      return [[],[]] if headers.empty?

      id = headers.first.id
      headers = @headers.select { |h| h.id == id }
      entries = @entries.select { |e| e.id == id }
      [headers, entries]
    end

    def device_present?(device)
      @headers.any? { |h| h.name == device }
    end

  end

end; end
