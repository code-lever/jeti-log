module Jeti; module Log;

  class Header < Entry

    def initialize(time, id, details)
      super
    end

    def name
      @details[2]
    end

  end

end; end
