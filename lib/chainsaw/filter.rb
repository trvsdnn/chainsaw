module Chainsaw
  class Filter
    attr_reader :line_count

    # Initialize a Filter instance. We read the logfile here and
    # attempt to detect what type of logfile it is.
    #
    # logfile - the String path of the logfile to be filtered
    # range  - the "time" range to filter through (Time or Range)
    # options - an OpenStruct representing the options
    #
    # Returns the Filter instance
    def initialize(logfile, range, options = OpenStruct.new)
      @logfile    = logfile
      @range      = range
      @options    = options
      @log        = File.open(@logfile)
      @line_count = 0

      self
    end

    # Start iterating through the log lines and filtering them accordingly.
    def start
      @ofilter = @options.filter

      File.open(@logfile).each do |line|
        if !@detected && @format = Detector.detect(line)
          @detected = true
          @log.rewind
        elsif @format.nil?
          next
        end

        begin
          match = line.match(@format.pattern)
        rescue ArgumentError
          line.encode!("UTF-8", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '?')
          redo
        end

        if match
          timestamp = match[1]
          time      = Filter.parse_timestamp(timestamp, @format.time_format)
        else
          timestamp = time = nil
        end

        # a match was found if we are filtering additional text, check that too
        if match && @range.cover?(time) && ( !@ofilter || @ofilter && line.include?(@ofilter) )
          found(line, timestamp)
        # a match was found and we are outputting non-timestamped lines
        elsif match && @outputting
          @outputting = false
        # outputting non-timestamped lines
        elsif @outputting
          out(line)
        end
      end

      unless @options.output_file
        hind = (@line_count.zero? || @line_count > 1) ? 's' : ''
        puts "\n\033[33mFound #{@line_count} line#{hind} \033[0m"
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

    # Parse a timestamp using the given time_format.
    #
    # timestamp - the String timestamp
    # time_format - the String time format used to parse
    #
    # Returns a parsed Time object
    def self.parse_timestamp(timestamp, time_format)
      dt = DateTime.strptime(timestamp, time_format)

      Time.local(dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec)
    end


    # A convinence method to initialize a Filter object using the
    # given args and start filtering it
    def self.filter(*args)
      new(*args).start
    end
  end
end
