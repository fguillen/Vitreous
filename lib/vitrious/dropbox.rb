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
    def index( cache = false )
      return YAML.load_file( Vitrious::Dropbox.index_cache_path )  if File.exists?( Vitrious::Dropbox.index_cache_path ) && cache
      
      collections = {}
      
      dir = @session.entry( '/Public/Vitrious' )
      dir.list.each do |element|
        if( element.directory? )
          collection = self.create_collection( element.path )
          collections[ collection[:slug] ] = collection
        end
      end
      
      # root collection
      collections['_root'] = self.create_collection( '/Public/Vitrious' )
      
      # cache it
      File.open( Vitrious::Dropbox.index_cache_path, 'w' ) { |f| f.write collections.to_yaml }
      
      return collections
    end
    
    # Returns the title of the Collection and a hash of ItemHashs
    #
    def create_collection( path )
      items = {}
      
      dir = @session.entry( path )
      dir.list.each do |element|
        if( File.extname( element.path ) =~ /^\.(jpg|png)$/ )
          item = self.create_item( element.path )
          items[item[:slug]] = item
        end
      end

      collection = {
        :slug => Vitrious::Dropbox.path_to_slug( path ),
        :title => Vitrious::Dropbox.path_to_title( path ),
        :items => items
      }
      
      return collection
    end
    
    # Returns an ItemHash
    #
    def create_item( path )
      description_path = path.gsub( /#{File.extname(path)}$/, '.txt' )
      description = nil
      begin
        description = @session.download( description_path ) 
      rescue
        puts "Not exists description: #{description_path}"
      end
      
      item = {
        :slug => Vitrious::Dropbox.path_to_slug( path ),
        :title => Vitrious::Dropbox.path_to_title( path ),
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
    
    def self.index_cache_path
      return "#{File.dirname(__FILE__)}/../../config/index.yml"
    end
    
    def self.path_to_slug( path )
      return File.basename( path, File.extname( path ) ).downcase.gsub(/[^a-z0-9 -_]/,"").gsub('_', '-').gsub(/[ ]+/,"-")
    end
    
    def self.path_to_title( path )
      return File.basename( path, File.extname( path ) ).gsub( /^\d*(_|\s)/, '' )
    end
  end
end