module Jeti; module Log;

  class CompositeDatasetBuilder

    def self.build(file, clazz, device, primary, *others)
      primaries = file.value_dataset(device, primary)
      other_data = others.map { |o| file.value_dataset(device, o) }
      primaries.map do |raw|
        time = raw[0]
        f0 = raw[1]
        fn = other_data.map { |d| d.min_by { |dp| (dp[0] - time).abs }[1] }
        clazz.new(time, fn.unshift(f0))
      end
    end

  end

end; end
