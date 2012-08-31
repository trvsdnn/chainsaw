$LOAD_PATH.unshift(File.expand_path('../../test', __FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup

require 'minitest/autorun'
require 'minitest/pride'
require 'mocha'

require 'chainsaw'
