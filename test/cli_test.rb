require 'test_helper'

describe Chainsaw::CLI do
  CLI = Chainsaw::CLI

  before do
    @now = Time.at(234920834)
    Time.expects(:now).returns(@now)
  end

  it 'parses a minute interval' do
    time = CLI.parse_interval('3minutes')
    time.must_be_instance_of Time
    time.must_equal (@now - 180)
  end


end
