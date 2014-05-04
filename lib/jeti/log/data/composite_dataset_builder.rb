module Jeti; module Log; module Data

  class CompositeDatasetBuilder

    def self.build(file, clazz, device, primary, *others)
      primaries = if primary.is_a? Array
                    file.value_dataset(device, primary[0], primary[1])
                  else
                    file.value_dataset(device, primary)
                  end

      other_data = others.map do |other|
        if other.is_a? Array
          file.value_dataset(device, other[0], other[1])
        else
          file.value_dataset(device, other)
        end
      end

      primaries.map do |raw|
        time, f0 = raw
        fn = other_data.map { |d| d.min_by { |dp| (dp[0] - time).abs }[1] }
        clazz.new(time, fn.unshift(f0))
      end
    end

  end

end; end; end
