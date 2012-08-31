require 'test_helper'

describe Chainsaw::CLI do
  CLI = Chainsaw::CLI

  before do
    @now = Time.at(234920834)
    Time.expects(:now).at_least_once.returns(@now)
  end

  it 'parses a minute interval' do
    singular = CLI.parse_interval('3minutes')
    plural   = CLI.parse_interval('1minute')

    singular.must_be_instance_of Time
    singular.must_equal (@now - 180)
    plural.must_be_instance_of Time
    plural.must_equal (@now - 60)
  end

end
