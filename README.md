# Chainsaw

## Features

Parses a log file and returns lines matching the time period provided.

Chronic is used to parse the time strings, so any format chronic
supports, chainsaw supports. A list of supported formats can
be found here: [https://github.com/mojombo/chronic][https://github.com/mojombo/chronic]

## Installation
    
    gem install chainsaw

## Usage

        > chainsaw access.log 1 hour ago                  # entries from one hour ago to now
        > chainsaw access.log august                      # entries from August to now
        > chainsaw access.log 2012-08-06                  # entries from August 6th to now
        > chainsaw access.log 2012-08-27 10:00            # entries from August 27th at 10:00 to now

        # You can use a hypen to specify a time range (you can mix and match formats)

        > chainsaw access.log 2012-08-01 - 2012-09-17     # entries within August 1st and September 17th
        > chainsaw access.log august - yesterday          # entries within August and September

## Features

### Additional text filter

You can specify an additional simple text pattern to filter on top of the time arguments with the `-f` option.

    > chainsaw access.log -f GET 1 hour ago

### Colorize output

You can have chainsaw colorize the timestamp for easy scanning with the `-c` option.

    > chainsaw access.log -c GET 1 hour ago
    
### Interactive mode

If you want to print a line and wait for input (press return) before moving to the next found line, you can use the `-i` option.
    
    > chainsaw access.log -i GET 1 hour ago
    
### Output to a file

Chainsaw will output the found log lines to a file on the system if you specify with `-o FILENAME`.

    > chainsaw access.log yesterday -o yesterday.log

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
