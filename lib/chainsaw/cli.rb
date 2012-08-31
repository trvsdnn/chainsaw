module Chainsaw
  class CLI
    BANNER = <<-BANNER
    Usage: chainsaw LOGFILE INTERVAL

    Description:

      TODO

    BANNER

    def self.parse_options
      @options = {}

      @opts = OptionParser.new do |opts|
        opts.banner = BANNER.gsub(/^ {6}/, '')

        opts.separator ''
        opts.separator 'Options:'

        opts.on('-v', 'Print the version') do
          puts Chainsaw::VERSION
          exit
        end

        opts.on( '-h', '--help', 'Display this help.' ) do
          puts opts
          exit
        end
      end

      @opts.parse!
    end

    def self.parse_interval(interval)
      count, unit = interval.match(/^(\d+)([a-z]+)/i) do |m|
        [ m[1].to_i, m[2][0..-2] ]
      end

      time = case unit
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

      [ time, unit ]
    end

    def self.validate_logfile
    end

    def self.print_usage_and_exit!
      puts @opts
      exit
    end

    def self.run
      parse_options
      print_usage_and_exit! if ARGV.empty?

      logfile                 = ARGV.first
      interval, interval_unit = parse_interval(ARGV[1])

      Filterer.filter(logfile, interval, interval_unit)
    end
  end
end
