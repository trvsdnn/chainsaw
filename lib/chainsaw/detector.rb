module Chainsaw
  class Detector

    CLF_PATTERN          = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} - - \[(\d{2}\/[a-z]{3}\/\d{4}:\d{2}:\d{2}:\d{2}) -\d{4}\]/i
    APACHE_ERROR_PATTERN = /^\[[a-z]{3} [a-z]{3} \d{2} (\d{2}:\d{2}:\d{2}) \d{4}\]/i
    NGINX_ERROR_PATTERN  = /\d{4}\/\d{2}\/\d{2} (\d{2}:\d{2}:\d{2})/

    def self.detect(line)
      detected = Detected.new

      case line
      when CLF_PATTERN
        detected.type        = 'clf'
        detected.time_format = '%d/%b/%Y:%H:%M:%S'
        detected.pattern     = CLF_PATTERN
      when APACHE_ERROR_PATTERN
        detected.type        = 'apache_error'
        detected.time_format = '%a /%b /%d %H:%M:%S %Y'
        detected.pattern     = APACHE_ERROR_PATTERN
      when NGINX_ERROR_PATTERN
        detected.type        = 'nginx_error'
        detected.time_format = '%Y/%m/%d %H:%M:%S'
        detected.pattern     = NGINX_ERROR_PATTERN
      end

      detected
    end

  end
end
