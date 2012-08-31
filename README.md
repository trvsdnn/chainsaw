# Chainsaw

## Features

Give a timeframe, an hour ago, three weeks ago, etc, and return all log entries from then to now 

Give a date range, August 1 - August 5, and return the long entries from the first date to the second date

Use the timeframe or date range, give a search term, and only return the log lines that contain the search word

Some sort of coloring scheme

The option to put the results out to a file

## What we started with

    log            = File.open ('/home/josh/work/application.log')
    starting_at    = /2012-08-28T20:00/
    ending_at      = /2012-08-29T20:00/
    printing       = false

    log.each_line do |line|
      if line.match(starting_at) || printing
        puts line
        printing = true
      end

      if line.match(ending_at)
        puts
        puts 'Log parse complete.'
        break
      end
    end

## Installation

Add this line to your application's Gemfile:

    gem 'chainsaw'
=======
* whatever
* blah

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
