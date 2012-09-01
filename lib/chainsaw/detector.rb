module Chainsaw
  class Detector

    CLF_PATTERN          = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} (?:-|[^ ]+) (?:-|[^ ]+) \[(\d{2}\/[a-z]{3}\/\d{4}:\d{2}:\d{2}:\d{2} -\d{4})\]/i
    APACHE_ERROR_PATTERN = /^\[[a-z]{3} [a-z]{3} \d{2} (\d{2}:\d{2}:\d{2}) \d{4}\]/i
    NGINX_ERROR_PATTERN  = /\d{4}\/\d{2}\/\d{2} (\d{2}:\d{2}:\d{2})/

    def self.detect(line)
      format = Format.new

      case line
      when CLF_PATTERN
        format.type        = 'clf'
        format.time_format = '%d/%b/%Y:%H:%M:%S %z'
        format.pattern     = CLF_PATTERN
      when APACHE_ERROR_PATTERN
        format.type        = 'apache_error'
        format.time_format = '%a /%b /%d %H:%M:%S %Y'
        format.pattern     = APACHE_ERROR_PATTERN
      when NGINX_ERROR_PATTERN
        format.type        = 'nginx_error'
        format.time_format = '%Y/%m/%d %H:%M:%S'
        format.pattern     = NGINX_ERROR_PATTERN
      end

      format
    end

  end
end
