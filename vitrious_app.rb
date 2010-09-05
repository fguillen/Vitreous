require 'rubygems'
require 'bundler'
Bundler.require

require "#{File.dirname(__FILE__)}/lib/vitrious/dropbox.rb"
require "#{File.dirname(__FILE__)}/lib/vitrious/configurator.rb"
require "#{File.dirname(__FILE__)}/lib/vitrious/not_authorized_exception.rb"
require "#{File.dirname(__FILE__)}/lib/vitrious/helpers.rb"

class VitriousApp < Sinatra::Base
  helpers Vitrious::Helpers
  
  config_file_path = File.exists?("#{File.dirname(__FILE__)}/config/config.yml") ? "#{File.dirname(__FILE__)}/config/config.yml" : "#{File.dirname(__FILE__)}/config/config.yml.template"
  APP_CONFIG = YAML.load_file(config_file_path)[environment]
  
  set :views, "#{File.dirname(__FILE__)}/views"
  set :public, "#{File.dirname(__FILE__)}/public"
  set :root, File.dirname(__FILE__)
  set :static, true
  
  configure :production do
    Vitrious::Dropbox.cache = true
    set :raise_errors, false 
    set :show_exceptions, false
    
    log = File.new("#{File.dirname(__FILE__)}/log/sinatra.log", "a")
    STDOUT.reopen(log)
    STDERR.reopen(log)
  end
  
  before do
  end

  get '/' do
    charge_collections
    @collection = @collections['_root']
    @title = APP_CONFIG[:website_name]
    erb :collection
  end
  
  get '/authorize/:pass' do
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
  
  get '/refresh/:pass' do
    return not_found  unless params['pass'] == APP_CONFIG[:pass]
    
    File.delete( Vitrious::Dropbox.index_cache_path )
    redirect '/'
  end
  
  get '/:collection_slug/:item_slug' do
    charge_collections
    @collection = @collections[params[:collection_slug]]
    return not_found unless @collection
    
    @item = @collection[:items][params[:item_slug]]
    return not_found unless @item
    
    @title = "#{APP_CONFIG[:website_name]} | #{@item[:title]}"

    erb :show
  end
  
  get '/:collection_slug' do
    charge_collections
    @collection = @collections[params[:collection_slug]]
    return not_found unless @collection
    
    @title = "#{APP_CONFIG[:website_name]} | #{@collection[:title]}"
    
    erb :collection
  end
  
  not_found do
    "Pagina no encontrada | Page not found"
  end
  
  error Vitrious::NotAuthorizedException do
    "Sesion no autorizada | Not authorized session"
  end
  
  error OAuth::Unauthorized do
    "Error en conexion con Dropbox comprueba tus credenciales | Error connecting to Dropbox, check your credentials"
  end
  
  private
  
    def charge_collections
      @collections = Vitrious::Dropbox.new( dropbox_session ).index
    end
    
    def dropbox_session
      @dropbox_session ||= Vitrious::Dropbox.deserialize
      
      raise Vitrious::NotAuthorizedException  unless @dropbox_session.authorized?

      return @dropbox_session
    end
end