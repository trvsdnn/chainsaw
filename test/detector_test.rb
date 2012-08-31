require 'test_helper'

describe Chainsaw::Detector do
  Detector = Chainsaw::Detector

  it 'detects an apache access log format' do
    line     = get_log_line('apache_access.log')
    detected = Detector.detect(line)

    detected.type.must_equal 'apache_access'
    detected.time_format.must_equal '%d/%b/%Y:%H:%M:%S'
  end

  def get_log_line(logfile)
    logfile = File.expand_path("../logs/#{logfile}", __FILE__)
    File.open(logfile).first
  end

end
