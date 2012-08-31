module Chainsaw
  class Detected
    attr_accessor :type
    attr_accessor :time_format

    def initialize
    end

    def pattern(time = Time.now)
      Detector.send("#{type}_pattern".to_sym, time.strftime(time_format))
    end
  end
end
