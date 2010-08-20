require File.expand_path( "#{File.dirname(__FILE__)}/../test_helper" )

class DropboxTest < Test::Unit::TestCase
  def test_index
    session = Dropbox::Session.new('14lc8xjqtfhfdrp', 'tcjcpjdmtpo089k')
    session.mode = :dropbox
    puts session.authorize_url
    gets
    session.authorize
    File.open( File.expand_path( "#{File.dirname(__FILE__)}/fixtures/session.serialized" ), 'w' ) do |f|
      f.write session.serialize
    end
    puts session.authorized?
  end
  
  def test_index_authorized
    session = Dropbox::Session.deserialize( File.read( File.expand_path( "#{File.dirname(__FILE__)}/../fixtures/session.serialized" ) ) )
    session.mode = :dropbox
    puts session.authorized?
    
    puts "account: #{session.account}"
    
    dropbox_utility = Vitrious::Dropbox.new( session )
    dropbox_utility.index.each_pair do |title, items|
      puts title
      puts "---"
      items.each do |item|
        puts item.inspect
      end
    end
  end
end