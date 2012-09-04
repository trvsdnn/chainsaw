require 'test_helper'

describe Chainsaw::Filter do
  Filter = Chainsaw::Filter
  before :each do
    FileUtils.mkdir_p(ENV['HOME'])
  end

  it 'finds the correct number of lines given an interval' do
    logfile = File.expand_path('../logs/clf.log', __FILE__)
    # stub out an interval of 11 hours from the last log entry
    starting = Time.local(2012, 8, 30, 10, 51, 05)
    ending   = Time.now
    filter   = Filter.new(logfile, starting..ending)

    capture_io { filter.start }
    filter.line_count.must_equal 18
  end

  it 'handles non-matching lines if occuring between the bounds' do
    logfile = File.expand_path('../logs/rails.log', __FILE__)
    # stub out a 1 hour range
    starting  = Time.local(2012, 9, 1, 10, 30, 00)
    ending    = Time.local(2012, 9, 1, 11, 30, 00)
    filter    = Filter.new(logfile, starting..ending)

    out, err = capture_io { filter.start }

    out.must_include "Processing by RegistrationsController#new as HTML"
    out.must_include "Rendered registrations/new.html.erb within layouts/application (5.2ms)"
    out.must_include "Completed 200 OK in 15ms (Views: 14.1ms)"
    filter.line_count.must_equal 13
  end

  it 'finds the correct number of lines given an interval and an additional text filter' do
    logfile = File.expand_path('../logs/clf.log', __FILE__)
    # stub out an interval of 11 hours from the last log entry
    starting = Time.local(2012, 8, 30, 10, 51, 05)
    ending   = Time.now
    options  = OpenStruct.new(:filter => 'green_bullet')
    filter   = Filter.new(logfile, starting..ending, options)

    capture_io { filter.start }
    filter.line_count.must_equal 1
  end

  it 'colorizes matching lines' do
    logfile  = File.expand_path('../logs/clf.log', __FILE__)
    starting = Time.local(2012, 8, 30, 10, 51, 05)
    ending   = Time.now
    options  = OpenStruct.new(:colorize => true)
    filter   = Filter.new(logfile, starting..ending, options)

    out, err = capture_io {filter.start}
    line     = out.split("\n").first
    line.must_equal %Q{127.0.0.1 - - [\e[32m30/Aug/2012:15:00:28 -0400\e[0m] "HEAD / HTTP/1.1" 200 338 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.19 (KHTML, like Gecko) Ubuntu/12.04 Chromium/18.0.1025.168 Chrome/18.0.1025.168 Safari/535.19"}
  end

  it 'goes interactive' do
    logfile  = File.expand_path('../logs/clf.log', __FILE__)
    starting = Time.local(2012, 8, 30, 10, 51, 05)
    ending   = Time.now
    options  = OpenStruct.new(:interactive => true)
    filter   = Filter.new(logfile, starting..ending, options)

    STDIN.expects(:gets).times(18).returns('')
    capture_io { filter.start }
  end

  it 'outputs to a file' do
    logfile     = File.expand_path('../logs/clf.log', __FILE__)
    starting    = Time.local(2012, 8, 30, 10, 51, 05)
    ending      = Time.now
    output_file = File.expand_path('../logs/output.log', __FILE__)
    options     = OpenStruct.new(:output_file => output_file)
    filter      = Filter.new(logfile, starting..ending, options)

    capture_io { filter.start }
    File.exists?(output_file).must_equal true
    File.open(output_file).first.must_equal "127.0.0.1 - - [30/Aug/2012:15:00:28 -0400] \"HEAD / HTTP/1.1\" 200 338 \"-\" \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.19 (KHTML, like Gecko) Ubuntu/12.04 Chromium/18.0.1025.168 Chrome/18.0.1025.168 Safari/535.19\"\n"
    File.delete(output_file)
  end
end
