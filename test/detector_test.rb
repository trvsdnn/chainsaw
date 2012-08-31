require 'test_helper'

describe Chainsaw::Detector do
  Detector = Chainsaw::Detector

  it 'detects a log format and returns a pattern given a Time' do
    line         = get_log_line('apache_access.log')
    detected     = Detector.detect(line)
    now          = Time.now
    time_pattern = now.strftime(detected.time_format)

    detected.pattern(now).must_equal /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3} - - \[#{time_pattern} -\d{4}\]/i
  end

  it 'detects an apache access log format' do
    line     = get_log_line('apache_access.log')
    detected = Detector.detect(line)

    detected.type.must_equal 'apache_access'
    detected.time_format.must_equal '%d/%b/%Y:%H:%M:%S'
  end

  it 'detects an apache error log format' do
    line     = get_log_line('apache_error.log')
    detected = Detector.detect(line)

    detected.type.must_equal 'apache_error'
    detected.time_format.must_equal '%a /%b /%d %H:%M:%S %Y'
  end

  it 'detects an nginx error log format' do
    line     = get_log_line('nginx_error.log')
    detected = Detector.detect(line)

    detected.type.must_equal 'nginx_error'
    detected.time_format.must_equal '%Y/%m/%d %H:%M:%S'
  end

  def get_log_line(logfile)
    logfile = File.expand_path("../logs/#{logfile}", __FILE__)
    File.open(logfile).first
  end

end
