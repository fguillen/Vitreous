ENV['RACK_ENV'] = 'test'

require "#{File.dirname(__FILE__)}/../vitrious_app.rb"
require 'rubygems'
require 'test/unit'
Bundler.require :test