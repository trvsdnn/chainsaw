require 'test_helper'

describe Chainsaw::Filter do
  Filter = Chainsaw::Filter
  before :each do
    FileUtils.mkdir_p(ENV['HOME'])
  end

  it 'finds the correct number of lines given an interval' do
    logfile = File.expand_path('../logs/clf.log', __FILE__)
    # stub out an interval of 11 hours from the last log entry
    time    = DateTime.strptime('30/Aug/2012:10:51:05', '%d/%b/%Y:%H:%M:%S').to_time
    filter  = Filter.new(logfile, time)

    capture_io { filter.start }
    filter.line_count.must_equal 18
  end

  it 'finds the correct number of lines given an interval and pattern' do
    logfile = File.expand_path('../logs/clf.log', __FILE__)
    # stub out an interval of 11 hours from the last log entry
    time    = DateTime.strptime('30/Aug/2012:10:51:05', '%d/%b/%Y:%H:%M:%S').to_time
    options = OpenStruct.new(:filter => 'green_bullet')
    filter  = Filter.new(logfile, time, options)

    capture_io { filter.start }
    filter.line_count.must_equal 1
  end

  it 'colorizes matching lines' do
    logfile = File.expand_path('../logs/clf.log', __FILE__)
    time    = DateTime.strptime('30/Aug/2012:10:51:05', '%d/%b/%Y:%H:%M:%S').to_time
    options = OpenStruct.new(:colorize => true)
    filter  = Filter.new(logfile, time, options)

    out, err = capture_io {filter.start}
    line     = out.split("\n").first
    line.must_equal %Q{127.0.0.1 - - [\e[32m30/Aug/2012:15:00:28 -0400\e[0m] "HEAD / HTTP/1.1" 200 338 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.19 (KHTML, like Gecko) Ubuntu/12.04 Chromium/18.0.1025.168 Chrome/18.0.1025.168 Safari/535.19"}
  end

  it 'goes interactive' do
    logfile = File.expand_path('../logs/clf.log', __FILE__)
    time    = DateTime.strptime('30/Aug/2012:10:51:05', '%d/%b/%Y:%H:%M:%S').to_time
    options = OpenStruct.new(:interactive => true)
    filter  = Filter.new(logfile, time, options)

    STDIN.expects(:gets).times(18).returns('')
    capture_io { filter.start }
  end

  it 'outputs to a file' do
    logfile     = File.expand_path('../logs/clf.log', __FILE__)
    time        = DateTime.strptime('30/Aug/2012:10:51:05', '%d/%b/%Y:%H:%M:%S').to_time
    output_file = File.expand_path('../logs/output.log', __FILE__)
    options     = OpenStruct.new(:output_file => output_file)
    filter      = Filter.new(logfile, time, options)

    capture_io { filter.start }
    File.exists?(output_file).must_equal true
    File.open(output_file).first.must_equal "127.0.0.1 - - [30/Aug/2012:15:00:28 -0400] \"HEAD / HTTP/1.1\" 200 338 \"-\" \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.19 (KHTML, like Gecko) Ubuntu/12.04 Chromium/18.0.1025.168 Chrome/18.0.1025.168 Safari/535.19\"\n"
    File.delete(output_file)
  end
end