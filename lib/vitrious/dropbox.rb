module Vitrious
  class Dropbox
    
    def initialize( session )
      @session = session
      @uid = @session.account.uid
    end
    
    
    # Returns a hash like this:
    #     {
    #       'title collection 1' => {
    #         'title item 1' => item_hash,
    #         'title item 2' => item_hash
    #       },
    #       'title collection 2' => {    
    #         'title item 1' => item_hash
    #       }
    #     }
    #
    def index
      collections = {}
      
      dir = @session.entry( '/Public/Vitrious' )
      dir.list.each do |element|
        if( element.directory? )
          title, items = self.create_collection( element.path )
          collections[title] = items
        end
      end
      
      puts "XXX: collections: #{collections.inspect}"
      return collections
    end
    
    # Returns the title of the Collection and a hash of ItemHashs
    #
    def create_collection( path )
      puts "XXX: create_collection(#{path})"
      title = File.basename( path )
      items = {}
      
      dir = @session.entry( path )
      dir.list.each do |element|
        if( File.extname( element.path ) =~ /^\.(jpg|png)$/ )
          item = self.create_item( element.path )
          items[item[:title]] = item
        end
      end
      
      return title, items
    end
    
    # Returns an ItemHash
    #
    def create_item( path )
      description_path = path.gsub( /#{File.extname(path)}$/, '.txt' )
      description = nil
      begin
        description = @session.download( description_path )
      rescue
        puts "XXX: #{description_path} doesn't exists"
      end
      
      item = {
        :title => File.basename( path, File.extname( path ) ),
        :url => "http://dl.dropbox.com/u/#{@uid}/#{path.gsub( /^\/Public\//, '' )}",
        :description => description
      }
      
      return item
    end
    
    def self.serialize( session )
      File.open( Vitrious::Dropbox.session_path, 'w' ) do |f|
        f.write session.serialize
      end
    end
    
    def self.deserialize
      session = ::Dropbox::Session.deserialize( File.read( Vitrious::Dropbox.session_path ) )
      session.mode = :dropbox
      return session
    end
    
    def self.serialized?
      return File.exists?( Vitrious::Dropbox.session_path )
    end
    
    def self.session_path
      return "#{File.dirname(__FILE__)}/../../config/session.serialized"
    end
  end
end