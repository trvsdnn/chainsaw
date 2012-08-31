require 'test_helper'

describe Chainsaw::Detector do
  Detector = Chainsaw::Detector

  it 'detects CLF log format' do
    line     = get_log_line('clf.log')
    detected = Detector.detect(line)

    detected.type.must_equal 'clf'
    detected.time_format.must_equal '%d/%b/%Y:%H:%M:%S'
  end

  it 'detects an apache error log format' do
    line     = get_log_line('apache_error.log')
    detected = Detector.detect(line)

    detected.type.must_equal 'apache_error'
    detected.time_format.must_equal '%a /%b /%d %H:%M:%%S %Y'
  end

  it 'detects an nginx error log format' do
    line     = get_log_line('nginx_error.log')
    detected = Detector.detect(line)

    detected.type.must_equal 'nginx_error'
    detected.time_format.must_equal '%Y/%m/%d %H:%M:%%S'
  end

  def get_log_line(logfile)
    logfile = File.expand_path("../logs/#{logfile}", __FILE__)
    File.open(logfile).first
  end

end
