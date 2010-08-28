require File.expand_path( "#{File.dirname(__FILE__)}/test_helper" )

class DropboxTest < Test::Unit::TestCase
  def setup
    DummyDropbox.root_path = File.expand_path( "#{File.dirname(__FILE__)}/fixtures/dropbox" )
  end
  
  def test_index
    session = Dropbox::Session.new('key', 'secret')
    dropbox_utility = Vitrious::Dropbox.new( session )
    
    # index_yaml = dropbox_utility.index.to_yaml
    # File.open( "#{File.dirname(__FILE__)}/fixtures/index.yml", 'w' ) { |f| f.write index_yaml }
    
    assert_equal( YAML.load_file("#{File.dirname(__FILE__)}/fixtures/index.yml"), dropbox_utility.index)
  end
  
  def test_serialized
    Vitrious::Dropbox.stubs(:session_path).returns( "#{File.dirname(__FILE__)}/fixtures/session.serialized" )
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
  
  # Don't know what happend with this test.
  def test_deserialize
      Dropbox::Session.expects(:deserialize).returns( Dropbox::Session.new('','') )
    Vitrious::Dropbox.deserialize
  end
end