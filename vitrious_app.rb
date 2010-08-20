require 'sinatra/base'
require 'mustache/sinatra'
require 'dropbox'

$LOAD_PATH.unshift( File.dirname(__FILE__) )
require 'lib/vitrious/dropbox.rb'
# require 'lib/vitrious/collection.rb'
# require 'lib/vitrious/item.rb'


class VitriousApp < Sinatra::Base
  # register Mustache::Sinatra
  # require 'views/layout'

  # set :mustache, {
  #   :views     => "#{File.dirname(__FILE__)}/views/",
  #   :templates => "#{File.dirname(__FILE__)}/templates/"
  # }
  
  set :erb, {
    :views => "#{File.dirname(__FILE__)}/views/"
  }

  get '/' do
    puts "XXX: index"
    @title = "Mustache + Sinatra = Wonder"
    @collections = Vitrious::Dropbox.new(session).index
    erb :index
  end

  get '/:collection_title/:item_title' do
    puts "XXX: params: #{params.inspect}"
    @collections = Vitrious::Dropbox.new(session).index
    @item = @collections[params[:collection_title]][params[:item_title]]
    erb :show
  end

  
  private
  
    def session
      session = Dropbox::Session.deserialize( File.read( File.expand_path( "#{File.dirname(__FILE__)}/test/fixtures/session.serialized" ) ) )
      session.mode = :dropbox
      
      return session
    end
end