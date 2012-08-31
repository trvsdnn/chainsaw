module Chainsaw
  class Detector

    CLF_PATTERN = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} - - \[(\d{2}\/[a-z]{3}\/\d{4}:\d{2}:\d{2}:\d{2}) -\d{4}\]/i

    # def self.apache_error_pattern(time_pattern = /^\[[a-z]{3} [a-z]{3} \d{2} \d{2}:\d{2}:\d{2} \d{4}\]/)
    #   time_pattern = time_pattern_as_regexp(time_pattern)
    # 
    #   /^#{time_pattern} \[[a-z]+\]/i
    # end
    # 
    # def self.nginx_error_pattern(time_pattern = /\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2}/)
    #   time_pattern = time_pattern_as_regexp(time_pattern)
    # 
    #   /^#{time_pattern} \[[a-z]+\]/i
    # end

    def self.detect(line)
      detected = Detected.new

      case line
      when CLF_PATTERN
        detected.type        = 'clf'
        detected.time_format = '%d/%b/%Y:%H:%M:%S'
        detected.pattern     = CLF_PATTERN
      # when apache_error_pattern
      #   detected.type        = 'apache_error'
      #   detected.time_format = '%a /%b /%d %H:%M:%S %Y'
      # when nginx_error_pattern
      #   detected.type = 'nginx_error'
      #   detected.time_format = '%Y/%m/%d %H:%M:%S'
      end

      detected
    end

  end
end
