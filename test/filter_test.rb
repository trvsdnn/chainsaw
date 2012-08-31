require 'test_helper'

describe Chainsaw::Filter do
  Filter = Chainsaw::Filter

  it 'finds the correct number of lines given an interval' do
    logfile = File.expand_path('../logs/clf.log', __FILE__)
    # stub out an interval of 11 hours from the last log entry
    time   = DateTime.strptime('30/Aug/2012:10:51:05', '%d/%b/%Y:%H:%M:%S').to_time
    filter = Filter.new(logfile, time)

    capture_io { filter.start }
    filter.line_count.must_equal 18
  end

  it 'colorizes matching lines' do
    out = capture_io { filter.start }
    puts out.split("\n").first
  end

  it 'goes interactive' do
    STDIN.expects(gets).at_least_once
  end

  it 'outputs to a file' do
  end

end
