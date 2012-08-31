module Chainsaw
  class Detector
    APACHE_ACCESS_REGEX = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} - - \[\d{2}\/[a-z]{3}\/\d{4}:\d{2}:\d{2}:\d{2} -\d{4}\]/i
    APACHE_ERROR_REGEX  = /^\[[a-z]{3} [a-z]{3} \d{2} \d{2}:\d{2}:\d{2} \d{4}\]/i
    NGINX_ERROR_LOG     = /\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2}/

    attr_accessor :type
    attr_accessor :time_format

    def initialize
    end

    def self.detect(line)
      detected = new

      case line
      when APACHE_ACCESS_REGEX
        detected.type        = 'apache_access'
        detected.time_format = '%d/%b/%Y:%H:%M:%S'
      when APACHE_ERROR_REGEX
        detected.type        = 'apache_error'
        detected.time_format = '%a /%b /%d %H:%M:%S %Y'
      when NGINX_ERROR_LOG
        detected.type = 'nginx_error'
        detected.time_format = '%Y/%m/%d %H:%M:%S'
      end

      detected
    end

  end
end
