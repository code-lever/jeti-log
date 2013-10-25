module Jeti; module Log;

  class Entry

    attr_reader :id

    def initialize(time, id, details)
      @time = time
      @id = id
      @details = details
    end

    def time
      @time.to_i
    end

  end

end; end
