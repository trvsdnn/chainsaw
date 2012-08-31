module Chainsaw
  class Filter
    attr_reader :line_count

    def initialize(logfile, interval, options = OpenStruct.new)
      @logfile  = logfile
      @interval = interval
      @options  = options

      @log = File.open(@logfile)
      # TODO: rename detected
      @detected = Detector.detect(@log.first)
      @log.rewind

      self
    end

    def start
      @line_count = 0
      end_at      = @interval

      @log.each_line do |line|
        timestamp = line.match(@detected.pattern)[1]
        time      = DateTime.strptime(timestamp, @detected.time_format).to_time

        found(line, timestamp) if end_at < time
      end

      puts "\nFound #{@line_count} line(s)" unless @options.output_file
    end

    def found(line, timestamp)
      @line_count += 1

      if @options.output_file
        File.open(@options.output_file, 'a') { |f| f.write(line) }
      elsif @options.colorize
        puts line.sub(timestamp, "\033[32m#{timestamp}\033[0m")
      else
        puts line
      end

      STDIN.gets if @options.interactive && !@options.output_file
    end

    def self.filter(*args)
      new(*args).start
    end
  end
end
