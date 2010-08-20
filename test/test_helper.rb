$LOAD_PATH.unshift( "#{File.dirname(__FILE__)}/.." )
require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'vitrious_app.rb'
require 'lib/vitrious/dropbox.rb'
# require 'lib/vitrious/collection.rb'
# require 'lib/vitrious/item.rb'
require 'dropbox'