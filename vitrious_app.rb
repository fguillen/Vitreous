require 'rubygems'
require 'bundler'
Bundler.require

require "#{File.dirname(__FILE__)}/lib/vitrious/dropbox.rb"
require "#{File.dirname(__FILE__)}/lib/vitrious/configurator.rb"

class VitriousApp < Sinatra::Base
  APP_CONFIG = YAML.load_file(File.dirname(__FILE__) + "/config/config.yml")
  
  before do
  end

  get '/' do
    @collections = Vitrious::Dropbox.new( dropbox_session ).index
    @title = APP_CONFIG[:website_name]
    erb :index
  end
  
  get '/authorize/:pass' do
    puts "XXX: params.inspect: #{params.inspect}"
    return not_found  unless params['pass'] == APP_CONFIG[:pass]

    dropbox_session = Dropbox::Session.new( APP_CONFIG[:dropbox_consumer_key], APP_CONFIG[:dropbox_consumer_secret] )
    Vitrious::Dropbox.serialize( dropbox_session )
    redirect dropbox_session.authorize_url(:oauth_callback => "http://#{request.env['HTTP_HOST']}/authorize_confirm/#{APP_CONFIG[:pass]}")
  end
  
  get '/authorize_confirm/:pass' do
    return not_found  unless params['pass'] == APP_CONFIG[:pass]

    dropbox_session = Vitrious::Dropbox.deserialize
    dropbox_session.authorize(params)
    Vitrious::Dropbox.serialize( dropbox_session )
    redirect '/'
  end

  get '/:collection_title/:item_title' do
    @collections = Vitrious::Dropbox.new( dropbox_session ).index
    @item = @collections[params[:collection_title]][params[:item_title]]
    @title = "#{APP_CONFIG[:website_name]} | @item[:title]"
    return not_found unless @item
    
    erb :show
  end
  
  not_found do
    "Página no encotrada | Page not found"
  end

  
  private
  
    def dropbox_session
      puts "XXX: dropbox_session"
      @dropbox_session ||= Vitrious::Dropbox.deserialize
      
      puts "XXX: @dropbox_session.authorized?: #{@dropbox_session.authorized?}"
      return @dropbox_session
    end
end