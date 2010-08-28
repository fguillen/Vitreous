require File.expand_path( "#{File.dirname(__FILE__)}/test_helper" )

class DropboxTest < Test::Unit::TestCase
  def setup
    DummyDropbox.root_path = File.expand_path( "#{File.dirname(__FILE__)}/fixtures/dropbox" )
    Vitrious::Dropbox.stubs(:index_cache_path).returns( "#{File.dirname(__FILE__)}/fixtures/index.yml.tmp" )
    Vitrious::Dropbox.stubs(:session_path).returns( "#{File.dirname(__FILE__)}/fixtures/session.serialized" )
    @session = Dropbox::Session.new('key', 'secret')
  end
  
  def teardown
    File.delete( "#{File.dirname(__FILE__)}/fixtures/index.yml.tmp" )  if File.exists?( "#{File.dirname(__FILE__)}/fixtures/index.yml.tmp" )
  end
  
  def test_create_item
    item_yaml = Vitrious::Dropbox.new( @session ).create_item( "/Public/Vitrious/01_collection ordered/01_file ordered.jpg" ).to_yaml
    assert_equal( YAML.load_file( "#{File.dirname(__FILE__)}/fixtures/item.yml" ), YAML.load( item_yaml ) )
  end
  
  def test_create_collection
    collection_yaml = Vitrious::Dropbox.new( @session ).create_collection( "/Public/Vitrious/01_collection ordered" ).to_yaml
    assert_equal( YAML.load_file( "#{File.dirname(__FILE__)}/fixtures/collection.yml" ), YAML.load( collection_yaml ) )
  end
  
  def test_index
    dropbox_utility = Vitrious::Dropbox.new( @session )
    
    # index_yaml = dropbox_utility.index.to_yaml
    # File.open( "#{File.dirname(__FILE__)}/fixtures/index.yml", 'w' ) { |f| f.write index_yaml }
    
    assert_equal( YAML.load_file("#{File.dirname(__FILE__)}/fixtures/index.yml"), dropbox_utility.index)
  end
  
  def test_index_should_cache_result
    Vitrious::Dropbox.new( @session ).index
    
    assert( File.exists?( "#{File.dirname(__FILE__)}/fixtures/index.yml.tmp" ) )
  end
  
  def test_serialized
    assert( Vitrious::Dropbox.serialized? )
  end
  
  def test_serialize
    Vitrious::Dropbox.stubs(:session_path).returns( "#{File.dirname(__FILE__)}/fixtures/session.serialized.test" )
    
    session = mock()
    session.expects(:serialize).returns('session serialized')
    
    Vitrious::Dropbox.serialize( session )
    
    assert_equal( 'session serialized', File.read( Vitrious::Dropbox.session_path ) )
    
    File.delete( Vitrious::Dropbox.session_path )
  end
  
  def test_deserialize
    ::Dropbox::Session.stubs(:deserialize).returns( Dropbox::Session.new('','') )
    Vitrious::Dropbox.deserialize
  end
  
  def test_index_with_cache
    dropbox_utility = Vitrious::Dropbox.new( @session )
    assert_equal( YAML.load_file("#{File.dirname(__FILE__)}/fixtures/index.yml"), dropbox_utility.index(true) )
  end
  
  def test_path_to_slug
    assert_equal( "01-wadus-slg", Vitrious::Dropbox.path_to_slug( '/x/x/01_Wadus slúg.txt') )
    assert_equal( "01-wadus-slg", Vitrious::Dropbox.path_to_slug( '/x/x/01 Wadus slúg.txt') )
    assert_equal( "01-wadus-slg", Vitrious::Dropbox.path_to_slug( '/x/x/01 Wadus slúg/') )
  end
  
  def test_path_to_title
    assert_equal( "Wadus slúg", Vitrious::Dropbox.path_to_title( '/x/x/01_Wadus slúg.txt') )
    assert_equal( "Wadus slúg", Vitrious::Dropbox.path_to_title( '/x/x/01 Wadus slúg.txt') )
    assert_equal( "Wadus slúg", Vitrious::Dropbox.path_to_title( '/x/x/01 Wadus slúg/') )
  end
end