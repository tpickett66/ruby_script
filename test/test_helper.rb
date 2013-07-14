lib_dir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift lib_dir

require 'bundler'
Bundler.setup

require 'minitest/pride'
require 'minitest/hell'
require 'minitest/mock'
require 'pry'

require 'ruby_script'
