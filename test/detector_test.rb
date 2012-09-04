require 'test_helper'

describe Chainsaw::Detector do
  Detector = Chainsaw::Detector

  it 'detects CLF log format' do
    line   = get_log_line('clf.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'clf'
    time.must_equal Time.local(2012, 8, 26, 7, 42, 20)
  end

  it 'detects apache error log format' do
    line   = get_log_line('apache_error.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'apache_error'

    time.must_equal Time.local(2012, 8, 26, 7, 42, 20)
  end

  it 'detects nginx error log format' do
    line   = get_log_line('nginx_error.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'nginx_error'
    time.must_equal Time.local(2012, 8, 29, 7, 48, 59)
  end

  it 'detects ruby logger log format' do
    line   = get_log_line('ruby_logger.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'ruby_logger'
    time.must_equal Time.local(2012, 9, 1, 11, 21, 26)
  end

  it 'detects rails log format' do
    line   = get_log_line('rails.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'rails'
    time.must_equal Time.local(2012, 9, 1, 9, 34, 35)
  end

  it 'detects syslog log format' do
    line   = get_log_line('syslog.log')
    format = Detector.detect(line)
    time   = get_time(line, format)
    year = Time.now.year

    format.type.must_equal 'syslog'
    time.must_equal Time.local(2012, 8, 1, 17, 36, 55)
  end

  it 'detects redis log format' do
    line   = get_log_line('redis.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'redis'
    time.must_equal Time.local(2012, 4, 12, 18, 43, 33)
  end

  it 'detects puppet log format' do
    line   = get_log_line('puppet.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'puppet'
    time.must_equal Time.local(2012, 02, 04, 04, 8, 52)
  end

  it 'detects mongodb log format' do
    line   = get_log_line('mongodb.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'mongodb'
    time.must_equal Time.local(2012, 8, 26, 7, 43, 54)
  end

  it 'detects rack log format' do
    line   = get_log_line('rack.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'rack'
    time.must_equal Time.local(2012, 9, 03, 22, 51, 16)
  end

  it 'detects python log format' do
    line   = get_log_line('python.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'python'
    time.must_equal Time.local(2010, 12, 12, 11, 41, 42)
  end

  it 'detects django log format' do
    line   = get_log_line('django.log')
    format = Detector.detect(line)
    time   = get_time(line, format)

    format.type.must_equal 'django'
    time.must_equal Time.local(2012, 9, 03, 21, 49, 47)
  end


  def get_time(line, format)
    timestamp = line.match(format.pattern)[1]
    time      = Filter.parse_timestamp(timestamp, format.time_format)
  end

  def get_log_line(logfile)
    logfile = File.expand_path("../logs/#{logfile}", __FILE__)
    File.open(logfile).first
  end

end
