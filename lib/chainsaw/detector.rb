module Chainsaw
  class Detector

    # TODO: rename this stupid shit
    def self.time_pattern_as_regexp(time_pattern)
      if time_pattern.is_a? Regexp
        time_pattern = time_pattern.source
      else
        time_pattern = Regexp.escape(time_pattern).sub(/%S/, '\d{1,2}')
      end
    end

    def self.apache_access_pattern(time_pattern = /\d{2}\/[a-z]{3}\/\d{4}:\d{2}:\d{2}:\d{2}/)
      time_pattern = time_pattern_as_regexp(time_pattern)

      /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} - - \[#{time_pattern} -\d{4}\]/i
    end

    def self.apache_error_pattern(time_pattern = /^\[[a-z]{3} [a-z]{3} \d{2} \d{2}:\d{2}:\d{2} \d{4}\]/)
      time_pattern = time_pattern_as_regexp(time_pattern)

      /^#{time_pattern} \[[a-z]+\]/i
    end

    def self.nginx_error_pattern(time_pattern = /\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2}/)
      time_pattern = time_pattern_as_regexp(time_pattern)

      /^#{time_pattern} \[[a-z]+\]/i
    end

    def self.detect(line)
      detected = Detected.new

      case line
      when apache_access_pattern
        detected.type        = 'apache_access'
        detected.time_format = '%d/%b/%Y:%H:%M:%S'
      when apache_error_pattern
        detected.type        = 'apache_error'
        detected.time_format = '%a /%b /%d %H:%M:%S %Y'
      when nginx_error_pattern
        detected.type = 'nginx_error'
        detected.time_format = '%Y/%m/%d %H:%M:%S'
      end

      detected
    end

  end
end
