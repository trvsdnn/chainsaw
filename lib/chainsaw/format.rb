module Chainsaw
  class Format
    attr_accessor :type
    attr_accessor :time_format
    attr_accessor :pattern

    def initialize(type, attributes = {})
      @type = type
      attributes.each do |key, value|
        send(:"#{key}=", value)
      end
    end

  end
end
