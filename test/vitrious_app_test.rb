require File.expand_path( "#{File.dirname(__FILE__)}/test_helper" )
# ENV['RACK_ENV'] = 'test'
# set :environment, :test

class VitriousAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    VitriousApp
  end
  
  def setup
    DummyDropbox.root_path = File.expand_path( "#{File.dirname(__FILE__)}/fixtures/dropbox" )
    Vitrious::Dropbox.stubs(:session_path).returns( "#{File.dirname(__FILE__)}/fixtures/session.serialized" )
    Vitrious::Dropbox.stubs(:index_cache_path).returns( "#{File.dirname(__FILE__)}/fixtures/index.yml.tmp" )
  end
  
  def teardown
    File.delete( "#{File.dirname(__FILE__)}/fixtures/index.yml.tmp" )  if File.exists?( "#{File.dirname(__FILE__)}/fixtures/index.yml.tmp" )
  end

  def test_index
    get '/'
    
    assert_match( VitriousApp::APP_CONFIG[:website_name], last_response.body )
    assert_match( 'my portfolio test', last_response.body )
    assert_match( 'collection1', last_response.body )
    assert_match( 'collection2', last_response.body )
    assert_match( 'Index description', last_response.body )
    assert_match( '/Vitrious/index.jpg', last_response.body )
  end
  
  def test_authorize
    get '/authorize/pass'
    
    assert( last_response.redirect? )
    assert( 'dummy url', last_response.location )
  end

  def test_authorize_confirm
    dropbox_session = Dropbox::Session.new('','')
    Vitrious::Dropbox.stubs(:deserialize).returns( dropbox_session )
    dropbox_session.expects(:authorize)
    
    get '/authorize_confirm/pass'
    
    follow_redirect!

    assert_equal "http://example.org/", last_request.url
    assert last_response.ok?
  end
  
  def test_show
    get '/collection1/file1'
    assert( last_response.body.include?('my portfolio test | file1') )
    assert( last_response.body.include?('/Vitrious/collection1/file1.jpg') )
  end

  def test_collection
    get '/collection1'
    
    assert( last_response.body.include?('/Vitrious/collection1/file1.jpg') )
    assert( last_response.body.include?('/Vitrious/collection1/file2.jpg') )
  end
  
  def test_refresh
    File.expects(:delete).with( Vitrious::Dropbox.index_cache_path )
    get '/refresh/pass'
        
    assert( last_response.redirect? )
    assert( '/', last_response.location )
  end
  
  def test_404_on_item
    get '/not-exists/not-exists'
    assert_equal( 'Página no encotrada | Page not found', last_response.body )
    assert( last_response.not_found? )
  end
  
  def test_404_on_collection
    get '/not-exists'
    assert_equal( 'Página no encotrada | Page not found', last_response.body )
    assert( last_response.not_found? )
  end
end