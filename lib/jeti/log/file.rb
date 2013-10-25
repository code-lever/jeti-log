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
              # nothing
            else
              raise RuntimeError, "Unexpected header length (#{line.length})"
            end
            @headers << Header.new(line[0], line[1], line[2..4])
          else
            @entries << Entry.new(line[0], line[1], line[2..4])
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

    def rx_voltages?
      !rx_voltages.empty?
    end

    def rx_voltages
      @rx_voltages ||= entries(id_for('Rx', 'U Rx'))
    end

    private

    def entries(id)
      []
    end

    def id_for(device, sensor)

    end

  end

end; end
