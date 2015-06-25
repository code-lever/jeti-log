require 'open-uri'
require 'ruby_kml'

module Jeti

  module Log

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
          @name = /^#(.*)/.match(lines.fetch(:comments, ['# Unknown']).first)[1].strip

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

      def mgps_data?
        device_present?(/MGPS/)
      end

      def mgps_data
       @mgps_data ||= Data::MGPSDataBuilder.build(self)
      end

      def mezon_data?
        device_present?(/Mezon/i)
      end

      def mezon_data
        @mezon_data ||= Data::MezonDataBuilder.build(self)
      end

      def mui_data?
        device_present?(/MUI/)
      end

      def mui_data
        @mui_data ||= Data::MuiDataBuilder.build(self)
      end

      def rx_data?
        device_present?(/Rx/)
      end

      def rx_data
        @rx_data ||= Data::RxDataBuilder.build(self)
      end

      def tx_data?
        device_present?(/Tx/)
      end

      def tx_data
        @tx_data ||= Data::TxDataBuilder.build(self)
      end

      # Determines if KML methods can be called for this session.
      #
      # @return [Boolean] true if KML can be generated for this session, false otherwise
      def to_kml?
        mgps_data?
      end

      # Converts the session into a KML document containing a placemark.
      #
      # @param file_options [Hash] hash containing options for file
      # @param placemark_options [Hash] hash containing options for placemark
      # @return [String] KML document for the session
      # @see #to_kml_file file options
      # @see #to_kml_placemark placemark options
      def to_kml(file_options = {}, placemark_options = {})
        raise RuntimeError, 'No coordinates available for KML generation' unless to_kml?
        to_kml_file(file_options, placemark_options).render
      end

      # Converts the session into a KMLFile containing a placemark.
      #
      # @param file_options [Hash] hash containing options for file
      # @option file_options [String] :name name option of KML::Document
      # @option file_options [String] :description name option of KML::Document
      # @option file_options [String] :style_id id option of KML::Style
      # @param placemark_options [Hash] hash containing options for placemark
      # @return [KMLFile] file for the session
      # @see #to_kml_placemark placemark options
      def to_kml_file(file_options = {}, placemark_options = {})
        raise RuntimeError, 'No coordinates available for KML generation' unless to_kml?
        options = apply_default_file_options(file_options)

        kml = KMLFile.new
        kml.objects << KML::Document.new(
          name: options[:name],
          description: options[:description],
          styles: [
            KML::Style.new(
              id: options[:style_id],
              line_style: KML::LineStyle.new(color: '7F00FFFF', width: 4),
              poly_style: KML::PolyStyle.new(color: '7F00FF00')
            )
          ],
          features: [ to_kml_placemark(placemark_options) ]
        )
        kml
      end

      # Converts the session into a KML::Placemark containing GPS coordinates.
      #
      # @param options [Hash] hash containing options for placemark
      # @option options [String] :altitude_mode altitude_mode option of KML::LineString
      # @option options [Boolean] :extrude extrude option of KML::LineString
      # @option options [String] :name name option of KML::Placemark
      # @option options [String] :style_url style_url option of KML::Placemark
      # @option options [Boolean] :tessellate tessellate option of KML::LineString
      # @return [KML::Placemark] placemark for the session
      def to_kml_placemark(options = {})
        raise RuntimeError, 'No coordinates available for KML generation' unless to_kml?
        options = apply_default_placemark_options(options)

        coords = mgps_data.map { |l| [l.longitude, l.latitude, l.altitude] }
        KML::Placemark.new(
          name: options[:name],
          style_url: options[:style_url],
          geometry: KML::LineString.new(
            altitude_mode: options[:altitude_mode],
            extrude: options[:extrude],
            tessellate: options[:tessellate],
            coordinates: coords.map { |c| c.join(',') }.join(' ')
          )
        )
      end

      def value_dataset(device, sensor, modifier = ->(val) { val })
        headers, entries = headers_and_entries_for_device(device)
        sensor_id = (headers.select { |h| sensor =~ h.name })[0].sensor_id
        entries.reject! { |e| e.detail(sensor_id).nil? }
        entries.map { |e| [e.time, modifier.call(e.value(sensor_id))] }
      end

      private

      def apply_default_file_options(options)
        options = { name: 'Jeti MGPS Path' }.merge(options)
        options = { description: 'Session paths for GPS log data' }.merge(options)
        options = { style_id: 'default-poly-style' }.merge(options)
        options
      end

      def apply_default_placemark_options(options)
        options = { altitude_mode: 'absolute' }.merge(options)
        options = { extrude: true }.merge(options)
        options = { name: "Session (#{duration.round(1)}s)" }.merge(options)
        options = { style_url: '#default-poly-style' }.merge(options)
        options = { tessellate: true }.merge(options)
        options
      end

      def device_present?(device)
        @headers.any? { |h| device =~ h.name }
        # XXX improve, make sure there are entries
      end

      def headers_and_entries_for_device(device)
        headers = @headers.select { |h| device =~ h.name }
        return [[],[]] if headers.empty?

        id = headers.first.id
        headers = @headers.select { |h| h.id == id }
        entries = @entries.select { |e| e.id == id }
        [headers, entries]
      end

    end

  end

end
