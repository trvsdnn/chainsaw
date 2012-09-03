module Chainsaw
  class CLI
    CHRONIC_OPTIONS = { :context => :past, :guess => false }
    BANNER = <<-BANNER
    Usage: chainsaw LOGFILE INTERVAL [OPTIONS]

    Description: Parses log file and returns lines matching the interval or time period you provide

    Example:

      > chainsaw access.log 1 hour ago           # logs entries within one hour from now
      > chainsaw access.log 2012-08              # logs dated within August 2012
      > chainsaw access.log 2012-08-27           # logs dated within August 27th 2012
      > chainsaw access.log 2012-08-27T12:00     # logs dated within the hour of 12:00 on August 27th 2012
      > chainsaw access.log 2012-08 2012-09      # logs dated within August and September of 2012

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

    def self.parse_time_args(args)
      delimiter = args.index('-')

      if delimiter
        starting = Chronic.parse(args[0..(delimiter - 1)].join(' '), CHRONIC_OPTIONS).begin
        ending   = Chronic.parse(args[(delimiter + 1)..-1].join(' '), CHRONIC_OPTIONS).begin

        starting..ending
      else
        Chronic.parse(args.join(' '), CHRONIC_OPTIONS).begin
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

      logfile = ARGV.first
      time    = parse_time_args(ARGV[1..-1])

      trap(:INT) { exit }
      Filter.filter(logfile, interval, @options)
    end
  end
end
