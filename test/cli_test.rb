require 'test_helper'

describe Chainsaw::CLI do
  CLI = Chainsaw::CLI

  before do
  end

  it 'parses time as a single time if given without hyphen' do
    time = CLI.parse_time_args(['4:00'])
    time.must_be_kind_of Range
  end

  it 'parses time as a range if time args delimited by a hyphen' do
    time = CLI.parse_time_args(['4:00', '-', '5:00'])
    time.must_be_kind_of Range
  end

end
