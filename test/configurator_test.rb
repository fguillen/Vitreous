require File.expand_path( "#{File.dirname(__FILE__)}/test_helper" )

class ConfiguratorTest < Test::Unit::TestCase
  def test_do
    Vitrious::Configurator.stubs(:config_root_path).returns( "#{File.dirname(__FILE__)}/fixtures" )
    Vitrious::Configurator.do( { 'dropbox_consumer_key' => 'CONSUMER KEY', 'dropbox_consumer_secret' => 'CONSUMER SECRET' } )
    
    assert_equal( 
      File.read( "#{Vitrious::Configurator.config_root_path}/config.yml.fixed" ),
      File.read( "#{Vitrious::Configurator.config_root_path}/config.yml" )
    )
    
    File.delete( "#{Vitrious::Configurator.config_root_path}/config.yml" )
  end
end