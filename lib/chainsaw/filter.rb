module Chainsaw
  class Filter
    def self.filter(logfile, interval)
      log         = File.open(logfile)
      detected    = Detector.detect(log.first)
      starting_at = detected.pattern(interval)
      ending_at   = detected.pattern
      printing    = false

      log.rewind

      log.each_line do |line|
        if line.match(starting_at) || printing
          puts line
          printing = true
        end

        if line.match(ending_at)
          puts
          puts 'Log parse complete.'
          break
        end
      end
    end
  end
end
