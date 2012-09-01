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
        :colorize    => false
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

    # given a period of time from now: 3hours ago up to now
    # given a single datetime: all logs on that datetime
    # given two datetimes: all logs between the two datetimes

    def self.parse_datetime_args(args)
      if args.length > 1
        interval_for_date(args[0]).begin..interval_for_date(args[1]).end
      else
        # TODO: rename this variable
        time_string = args.first

        if time_string =~ /^(\d+)([a-z]+)/i
          parse_time_from_now(time_string)
        elsif time_string =~ /t/i
          interval_for_datetime(time_string)
        else
          interval_for_date(time_string)
        end
      end
    end

    def self.parse_time_from_now(distance)
      count, unit = distance.match(/^(\d+)([a-z]+)/i) do |m|
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

    # time_string can be a date with or without a time
    # if it's a date, we get all logs on that day
    # if it's a datetime we get all logs within the hour
    def self.interval_for_datetime(time_string)
      if time_string =~ /t\d{2}$/i
        starting = DateTime.parse(time_string << ':00').to_time
        ending   = start + 3600
      elsif time_string =~ /t\d{2}:\d{2}$/i
        starting = DateTime.parse(time_string << ':00').to_time
        ending   = start + 60
      end

      starting..ending
    end

    def self.interval_for_date(date_string)
      precision = date_string.split('-').size

      if precision == 2
        # TODO: some timezone problem here
        starting = DateTime.parse(date_string + '-01').to_time
        ending   = Date.new(starting.year, starting.month, -1).to_time + 86399
      elsif precision == 3
        starting = DateTime.parse(date_string).to_time
        ending   = starting + 86399
      end

      starting..ending
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

      logfile  = ARGV.first
      interval = parse_datetime_args(ARGV[1..-1])

      trap(:INT) { exit }
      Filter.filter(logfile, interval, @options)
    end
  end
end
