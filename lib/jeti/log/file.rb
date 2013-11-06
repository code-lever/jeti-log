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

    def gps
      build_gps_locations
    end

    private

    def build_gps_locations
      lats = build_raw_dataset('MGPS', 'Latitude')
      lons = build_raw_dataset('MGPS', 'Longitude')
      alts = build_raw_dataset('MGPS', 'Altitude')
      crse = build_raw_dataset('MGPS', 'Course')
      puts lats.length
      puts lons.length
      puts alts.length
      puts crse.length
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

    def build_raw_dataset(device, sensor)
      headers, entries = headers_and_entries_by_device(device)
      puts headers.length
      puts entries.length
      sensor_id = (headers.select { |h| h.name == sensor })[0].sensor_id
      puts "id: #{sensor_id}"
      #puts entries.inspect
      #entries.each do |e|
      #  puts e.detail(sensor_id)
      #end
      entries.reject! { |e| e.detail(sensor_id).nil? }
      v = entries.map { |e| [e.time, e.detail(sensor_id)] }
 #     puts "entries: #{v.inspect}"
      v
    rescue => e
      puts e
      []
    end

    def headers_and_entries_by_device(device)
      headers = @headers.select { |h| h.name == device }
      return [[],[]] if headers.empty?

      id = headers.first.id
      headers = @headers.select { |h| h.id == id }
      entries = @entries.select { |e| e.id == id }
      [headers, entries]
    end

  end

end; end
