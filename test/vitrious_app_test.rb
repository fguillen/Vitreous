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
end