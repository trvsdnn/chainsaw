module Chainsaw
  class Detector
    PATTERNS = {
      :clf =>  {
        :pattern     => /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} (?:-|[^ ]+) (?:-|[^ ]+) \[(\d{2}\/[a-z]{3}\/\d{4}:\d{2}:\d{2}:\d{2} -\d{4})\]/i,
        :time_format => '%d/%b/%Y:%H:%M:%S %z'
      },
      :apache_error => {
        :pattern     => /^\[([a-z]{3} [a-z]{3} \d{2} \d{2}:\d{2}:\d{2} \d{4})\]/i,
        :time_format => '%a %b %d %H:%M:%S %Y'
      },
      :nginx_error => {
        :pattern     => /^(\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2})/i,
        :time_format => '%Y/%m/%d %H:%M:%S'
      },
      :ruby_logger => {
        :pattern     => /^[a-z]{1}, \[(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})\.\d+ #\d+\]/i,
        :time_format => '%Y-%m-%dT%H:%M:%S'
      },
      :rails => {
        :pattern     => /^started [a-z]+ "[^"]+" for \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} at (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4})/i,
        :time_format => '%Y-%m-%d %H:%M:%S %z'
      },
      :syslog => {
        :pattern     => /^([a-z]{3}  ?\d{1,2} \d{2}:\d{2}:\d{2})/i,
        :time_format => '%b %e %H:%M:%S'
      },
      :redis => {
        :pattern     => /^\[\d+\]  ?(\d{1,2} [a-z]{3} \d{2}:\d{2}:\d{2})/i,
        :time_format => '%e %b %H:%M:%S'
      },
      :puppet => {
        :pattern     => /^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\]/i,
        :time_format => '%Y-%m-%d %H:%M:%S'
      },
      :mongodb => {
        :pattern     => /^(\w{3} \w{3} \d{2} \d{2}:\d{2}:\d{2})/i,
        :time_format => '%a %b %d %H:%M:%S'
      },
      :rack => {
        :pattern     => /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} (?:-|[^ ]+) (?:-|[^ ]+) \[(\d{2}\/[a-z]{3}\/\d{4} \d{2}:\d{2}:\d{2})\]/i,
        :time_format => '%d/%b/%Y %H:%M:%S'
      },
      :python => {
        :pattern     => /^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/i,
        :time_format => '%Y-%m-%d %H:%M:%S'
      },
      :django => {
        :pattern     => /^\[(\d{2}\/[a-z]{3}\/\d{4} \d{2}:\d{2}:\d{2})\]/i,
        :time_format => '%d/%b/%Y %H:%M:%S'
      }
    }

    def self.detect(log)
      type = nil

      log.each_line do |line|
        type = _detect(line)
        break unless type.nil?
      end

      if type.nil?
        puts "\033[31mUnable to determine log format :(\033[0m"
        exit
      else
        Format.new(type, PATTERNS[type])
      end
    end

    def self._detect(line)
      type = nil
      
      PATTERNS.each do |key, value|
        if line.match(value[:pattern])
          type = key
          break
        end
      end

      type
    end

  end
end
