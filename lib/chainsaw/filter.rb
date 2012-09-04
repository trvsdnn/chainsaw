module Chainsaw
  class Filter
    attr_reader :line_count

    # Initialize a Filter instance. We read the logfile here and
    # attempt to detect what type of logfile it is.
    #
    # logfile - the String path of the logfile to be filtered
    # bounds  - the "time" period to filter through (Time or Range)
    # options - an OpenStruct representing the options
    #
    # Returns the Filter instance
    def initialize(logfile, bounds, options = OpenStruct.new)
      @logfile    = logfile
      @bounds     = bounds
      @options    = options
      @log        = File.open(@logfile)
      @format     = Detector.detect(@log.first)
      @line_count = 0

      @log.rewind

      self
    end

    # Start iterating through the log lines and filtering them accordingly.
    def start
      @log.each_line do |line|
        filter    = @options.filter
        match     = line.match(@format.pattern)

        if match
          timestamp = match[1]
          time      = Filter.parse_timestamp(timestamp, @format.time_format)
        else
          timestamp = time = nil
        end

        # a match was found if we are filtering additional text, check that too
        if match && within_bounds?(time) && ( !filter || filter && line.include?(filter) )
          found(line, timestamp)
        # a match was found and we are outputting non-timestamped lines
        elsif match && @outputting
          @outputting = false
        # outputting non-timestamped lines
        elsif @outputting
          out(line)
        end
      end

      puts "\nFound #{@line_count} line(s)" unless @options.output_file
    end

    # Check to see if the parsed Time is within the bounds
    # of our given Time or time Range.
    #
    # time - the parsed Time from the logline
    #
    # Returns true if within bounds
    def within_bounds?(time)
      if @bounds.is_a? Range
        @bounds.cover?(time)
      else
        @bounds < time
      end
    end

    # A matching line was found, set @outputting incase we
    # run into lines that aren't timestamped.
    #
    # line - the String logline
    # timestamp - the String timestamp from the logline
    def found(line, timestamp)
      @outputting = true
      @line_count += 1

      out(line, timestamp)

      STDIN.gets if @options.interactive && !@options.output_file
    end

    # Output the logline to STDOUT or File. We also colorize if requested.
    #
    # line - the String logline
    # timestamp - the String timestamp from the logline
    def out(line, timestamp = nil)
      if @options.output_file
        File.open(@options.output_file, 'a') { |f| f.write(line) }
      elsif @options.colorize && timestamp
        puts line.sub(timestamp, "\033[32m#{timestamp}\033[0m")
      else
        puts line
      end
    end

    # Parse a timestamp using the given time_format. If a timezone
    # isn't included in the timestamp, we'll set it to the current local
    # timezone
    #
    # timestamp - the String timestamp
    # time_format - the String time format used to parse
    #
    # Returns the parsed Time object
    def self.parse_timestamp(timestamp, time_format)
      if time_format.include?('%z')
        dt = DateTime.strptime(timestamp, time_format)
      else
        # ugly, i know... find a better way
        timestamp   = timestamp + (Time.now.utc_offset / 3600).to_s
        time_format = time_format + ' %z'
        dt = DateTime.strptime(timestamp, time_format)
      end
      Time.local(dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec)
    end


    # A convinence method to initialize a Filter object using the
    # given args and start filtering it
    def self.filter(*args)
      new(*args).start
    end
  end
end
