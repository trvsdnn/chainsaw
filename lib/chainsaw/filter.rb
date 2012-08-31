module Chainsaw
  class Filter
    def self.filter(logfile, interval, interval_unit)
      log                    = File.open(logfile)
      detected               = Detector.detect(log.first)
      end_at                 = DateTime.now
      printing               = false

      log.rewind

      log.each_line do |line|
        timestamp = line.match(detected.pattern)[1]
        datetime  = DateTime.strptime(timestamp, detected.time_format)

        if datetime > end_at
          puts line
        end
      end
    end
  end
end
