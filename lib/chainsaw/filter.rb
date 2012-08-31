module Chainsaw
  class Filter
    def self.filter(logfile, interval, interval_unit)
      log                    = File.open(logfile)
      detected               = Detector.detect(log.first)
      end_at                 = interval
      printing               = false

      log.rewind

      log.each_line do |line|
        timestamp = line.match(detected.pattern)[1]
        time      = DateTime.strptime(timestamp, detected.time_format).to_time

        if end_at < time
          puts line
        end
      end

    end
  end
end
