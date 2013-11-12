module Jeti; module Log;

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
        time = raw[0]
        f0 = raw[1]
        fn = other_data.map { |d| d.min_by { |dp| (dp[0] - time).abs }[1] }
        clazz.new(time, fn.unshift(f0))
      end
    end

  end

end; end
