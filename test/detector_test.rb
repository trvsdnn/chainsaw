require 'test_helper'

describe Chainsaw::Detector do
  Detector = Chainsaw::Detector

  it 'detects CLF log format' do
    line   = get_log_line('clf.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'clf'
    time.must_equal Time.new(2012, 8, 26, 7, 42, 20)
  end

  it 'detects apache error log format' do
    line   = get_log_line('apache_error.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'apache_error'

    time.must_equal Time.new(2012, 8, 26, 7, 42, 20)
  end

  it 'detects nginx error log format' do
    line   = get_log_line('nginx_error.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'nginx_error'
    time.must_equal Time.new(2012, 8, 29, 7, 48, 59)
  end

  it 'detects ruby logger log format' do
    line   = get_log_line('ruby_logger.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'ruby_logger'
    time.must_equal Time.new(2012, 9, 1, 11, 21, 26)
  end

  it 'detects rails log format' do
    line   = get_log_line('rails.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'rails'
    time.must_equal Time.new(2012, 9, 1, 9, 34, 35)
  end

  def get_time(line, format)
    timestamp = line.match(format.pattern)[1]
    time      = Filter.parse_timestamp(timestamp, format.time_format).to_time
  end

  def get_log_line(logfile)
    logfile = File.expand_path("../logs/#{logfile}", __FILE__)
    File.open(logfile).first
  end

end
