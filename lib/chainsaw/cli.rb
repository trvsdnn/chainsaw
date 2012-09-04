module Chainsaw
  class CLI
    CHRONIC_OPTIONS = { :context => :past, :guess => false }
    BANNER = <<-BANNER
    Usage: chainsaw LOGFILE INTERVAL [OPTIONS]

    Description:
      Parses a log file and returns lines matching the time period provided.

      Chronic is used to parse the time strings, so any format chronic
      supports, chainsaw supports. A list of supported formats can
      be found here: https://github.com/mojombo/chronic

    Examples:

      > chainsaw access.log 1 hour ago                  # entries from one hour ago to now
      > chainsaw access.log august                      # entries from August to now
      > chainsaw access.log 2012-08-06                  # entries from August 6th to now
      > chainsaw access.log 2012-08-27 10:00            # entries from August 27th at 10:00 to now

      You can use a hypen to specify a time range (you can mix and match formats)

      > chainsaw access.log 2012-08-01 - 2012-09-17     # entries within August 1st and September 17th
      > chainsaw access.log august - yesterday          # entries within August and September

    BANNER

    # Use OptionParser to parse options, then we remove them from
    # ARGV to help ensure we're parsing times correctly
    def self.parse_options
      @options = OpenStruct.new({
        :interactive => false,
        :colorize    => false
      })

      @opts = OptionParser.new do |opts|
        opts.banner = BANNER.gsub(/^ {4}/, '')

        opts.separator ''
        opts.separator 'Options:'

        opts.on('-f [FILTER]', 'Provide a regexp pattern to match on as well as the interval given') do |filter|
          @options.filter = filter
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

    # Check the leftover arguments to see if we're given a range or not.
    # If we have a range, parse them, if not, parse the single time arguments.
    #
    # args - an Array of String arguments
    #
    # Returns a Time object or Range representing the requested time
    def self.parse_time_args(args)
      delimiter = args.index('-')

      if delimiter
        starting = Chronic.parse(args[0..(delimiter - 1)].join(' '), CHRONIC_OPTIONS).begin
        ending   = Chronic.parse(args[(delimiter + 1)..-1].join(' '), CHRONIC_OPTIONS).begin
      else
        starting = Chronic.parse(args.join(' '), CHRONIC_OPTIONS).begin
        ending   = Time.now
      end

      starting..ending
    rescue
      puts "\033[31mUnable to parse `#{args.join(' ')}'. Check \033[0m\033[4mhttps://github.com/mojombo/chronic\033[0m\033[31m to see time formats that chronic supports.\033[32m"
      exit
    end

    def self.print_usage_and_exit!
      puts @opts
      exit
    end

    # Called from the executable. Parses the command line arguments
    # and passes them through to Filter.
    def self.run
      parse_options
      print_usage_and_exit! if ARGV.empty?

      logfile = ARGV.first
      time    = parse_time_args(ARGV[1..-1])

      trap(:INT) { exit }
      Filter.filter(logfile, time, @options)
    end
  end
end
