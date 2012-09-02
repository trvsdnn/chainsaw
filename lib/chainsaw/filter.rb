module Chainsaw
  class Filter
    attr_reader :line_count

    def initialize(logfile, bounds, options = OpenStruct.new)
      @logfile  = logfile
      @bounds   = bounds
      @options  = options
      @log      = File.open(@logfile)
      @format = Detector.detect(@log.first)
      @log.rewind

      self
    end

    def start
      @line_count = 0

      @log.each_line do |line|
        filter    = @options.filter
        match     = line.match(@format.pattern)

        if match
          timestamp = match[1]
          time      = DateTime.strptime(timestamp, @format.time_format).to_time
        else
          timestamp = time = nil
        end

        if match && within_bounds(time) && ( !filter || filter && line.include?(filter) )
          found(line, timestamp)
        elsif match && @outputting
          @outputting = false
        elsif @outputting
          out(line)
        end
      end

      puts "\nFound #{@line_count} line(s)" unless @options.output_file
    end

    def within_bounds(time)
      if @bounds.is_a? Range
        @bounds.cover?(time)
      else
        @bounds < time
      end
    end

    def found(line, timestamp)
      @outputting = true
      @line_count += 1

      out(line, timestamp)

      STDIN.gets if @options.interactive && !@options.output_file
    end

    def out(line, timestamp = nil)
      if @options.output_file
        File.open(@options.output_file, 'a') { |f| f.write(line) }
      elsif @options.colorize && timestamp
        puts line.sub(timestamp, "\033[32m#{timestamp}\033[0m")
      else
        puts line
      end
    end

    def self.filter(*args)
      new(*args).start
    end
  end
end
