module Chainsaw
  class CLI
    BANNER = <<-BANNER
    Usage: chainsaw LOGFILE INTERVAL [OPTIONS]

    Description: Parses log file and returns lines matching the interval or time period you provide

    Example: chainsaw access.log 1hour
    BANNER

    def self.parse_options
      @options = OpenStruct.new({
        :interactive => false,
        :colorize => false
      })

      @opts = OptionParser.new do |opts|
        opts.banner = BANNER.gsub(/^ {4}/, '')

        opts.separator ''
        opts.separator 'Options:'

        opts.on('-p [PATTERN]', 'Provide a regexp pattern to match on as well as the interval given') do |pattern|
          @options.pattern = pattern
        end

        opts.on('-i', 'Work in interactive mode, one line at a time') do
          @options.interactive = true
        end

        opts.on('-c', 'Colorize output (dates and patterns given)') do
          @options.colorize = true
        end

        opts.on('-o [FILE]', 'Output the filtered lines to a file') do |file|
          @options.output_file = file
        end

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
        [ m[1].to_i, m[2].sub(/s$/, '') ]
      end

      case unit
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

    def self.print_usage_and_exit!
      puts @opts
      exit
    end

    def self.run
      parse_options
      print_usage_and_exit! if ARGV.empty?

      logfile                 = ARGV.first
      interval = parse_interval(ARGV[1])

      Filter.filter(logfile, interval, @options)
    end
  end
end
