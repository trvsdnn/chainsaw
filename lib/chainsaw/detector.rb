module Chainsaw
  class Detector

    CLF_PATTERN          = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} (?:-|[^ ]+) (?:-|[^ ]+) \[(\d{2}\/[a-z]{3}\/\d{4}:\d{2}:\d{2}:\d{2} -\d{4})\]/i
    APACHE_ERROR_PATTERN = /^\[([a-z]{3} [a-z]{3} \d{2} \d{2}:\d{2}:\d{2} \d{4})\]/i
    NGINX_ERROR_PATTERN  = /^(\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2})/i
    RUBY_LOGGER_PATTERN  = /^[a-z]{1}, \[(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})\.\d+ #\d+\]/i
    RAILS_PATTERN        = /^started [a-z]+ "[^"]+" for \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} at (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4})/i
    SYSLOG_PATTERN       = /^([a-z]{3}  ?\d{1,2} \d{2}:\d{2}:\d{2})/i
    REDIS_PATTERN        = /^\[\d+\]  ?(\d{1,2} [a-z]{3} \d{2}:\d{2}:\d{2})/i
    PUPPET_PATTERN       = /^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\]/i
    MONGODB_PATTERN      = /^(\w{3} \w{3} \d{2} \d{2}:\d{2}:\d{2})/i
    RACK_PATTERN         = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} (?:-|[^ ]+) (?:-|[^ ]+) \[(\d{2}\/[a-z]{3}\/\d{4} \d{2}:\d{2}:\d{2})\]/i
    PYTHON_PATTERN       = /^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/i
    DJANGO_PATTERN       = /^\[(\d{2}\/[a-z]{3}\/\d{4} \d{2}:\d{2}:\d{2})\]/i

    def self.detect(line)
      format = Format.new

      case line
      when CLF_PATTERN
        format.type        = 'clf'
        format.time_format = '%d/%b/%Y:%H:%M:%S %z'
        format.pattern     = CLF_PATTERN
      when APACHE_ERROR_PATTERN
        format.type        = 'apache_error'
        format.time_format = '%a %b %d %H:%M:%S %Y'
        format.pattern     = APACHE_ERROR_PATTERN
      when NGINX_ERROR_PATTERN
        format.type        = 'nginx_error'
        format.time_format = '%Y/%m/%d %H:%M:%S'
        format.pattern     = NGINX_ERROR_PATTERN
      when RUBY_LOGGER_PATTERN
        format.type        = 'ruby_logger'
        format.time_format = '%Y-%m-%dT%H:%M:%S'
        format.pattern     = RUBY_LOGGER_PATTERN
      when RAILS_PATTERN
        format.type        = 'rails'
        format.time_format = '%Y-%m-%d %H:%M:%S %z'
        format.pattern     = RAILS_PATTERN
      when SYSLOG_PATTERN
        format.type        = 'syslog'
        format.time_format = '%b %e %H:%M:%S'
        format.pattern     = SYSLOG_PATTERN
      when REDIS_PATTERN
        format.type        = 'redis'
        format.time_format = '%e %b %H:%M:%S'
        format.pattern     = REDIS_PATTERN
      when PUPPET_PATTERN
        format.type        = 'puppet'
        format.time_format = '%Y-%m-%d %H:%M:%S'
        format.pattern     = PUPPET_PATTERN
      when MONGODB_PATTERN
        format.type        = 'mongodb'
        format.time_format = '%a %b %d %H:%M:%S'
        format.pattern     = MONGODB_PATTERN
      when RACK_PATTERN
        format.type        = 'rack'
        format.time_format = '%d/%b/%Y %H:%M:%S'
        format.pattern     = RACK_PATTERN
      when PYTHON_PATTERN
        format.type        = 'python'
        format.time_format = '%Y-%m-%d %H:%M:%S'
        format.pattern     = PYTHON_PATTERN
      when DJANGO_PATTERN
        format.type        = 'django'
        format.time_format = '%d/%b/%Y %H:%M:%S'
        format.pattern     = DJANGO_PATTERN
      end

      format
    end

  end
end
