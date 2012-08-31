module Chainsaw
  class CLI
    BANNER = <<-BANNER
    Usage: chainsaw

    Description:

      TODO

    BANNER

    def self.parse_options
      @options = {}

      OptionParser.new do |opts|
        opts.banner = BANNER.gsub(/^ {6}/, '')

        opts.separator ''
        opts.separator 'Options:'

        opts.on('-v', 'Print the version') do
          puts Forward::Externals::VERSION
          exit
        end

        opts.on( '-h', '--help', 'Display this help.' ) do
          puts opts
          exit
        end
      end.parse!
    end

    def self.parse_interval(interval)
      count, unit = interval.match(/^(\d+)([a-z]+)/i) do |m|
        [ m[1].to_i, m[2][0..-2] ]
      end

      case unit
      when 'second'
        Time.now - count
      when 'minute'
        Time.now - (60 * count)
      when 'hour'
        Time.now - (3600 * count)
      when 'day'
        Time.now - (86400 * count)
      when 'week'
        Time.now - (604800 * count)
      when 'month'
        Time.now - (2592000 * count)
      when 'year'
        Time.now - (31536000 * count)
      end
    end

    def self.validate_logfile
      
    end

    def self.run
      parse_options
      logfile  = ARGV.first
      interval = parse_interval(ARGV[1])

    end
  end
end
