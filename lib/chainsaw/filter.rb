module Chainsaw
  class Filter
    def self.filter(logfile, interval, options)
      log        = File.open(logfile)
      detected   = Detector.detect(log.first)
      end_at     = interval
      line_count = 0

      log.rewind

      log.each_line do |line|
        timestamp = line.match(detected.pattern)[1]
        time      = DateTime.strptime(timestamp, detected.time_format).to_time

        if end_at < time
          line_count += 1

          if options.output_file
            File.open(options.output_file, 'a') { |f| f.write(line) }
          elsif options.colorize
            puts line.sub(timestamp, "\033[32m#{timestamp}\033[0m")
          else
            puts line
          end
        end
      end

      puts "\nFound #{line_count} line(s)" unless options.output_file
    end
  end
end
