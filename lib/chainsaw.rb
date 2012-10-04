require 'date'
require 'ostruct'
require 'optparse'

require 'chronic'

require 'chainsaw/cli'
require 'chainsaw/core_extensions'
require 'chainsaw/format'
require 'chainsaw/detector'
require 'chainsaw/filter'
require 'chainsaw/version'

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

module Chainsaw

end
