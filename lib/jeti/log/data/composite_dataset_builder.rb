module Jeti; module Log; module Data

  class CompositeDatasetBuilder

    def self.build(file, clazz, device, primary, *others)
      primaries = file.value_dataset(device, primary)

      other_data = others.map do |other|
        file.value_dataset(device, other)
      end

      primaries.map do |raw|
        time, f0 = raw
        fn = other_data.map { |d| d.min_by { |dp| (dp[0] - time).abs }[1] }
        clazz.new(time, fn.unshift(f0))
      end
    end

  end

end; end; end
