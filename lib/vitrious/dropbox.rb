

module Vitrious
  class Dropbox
    
    def initialize( session )
      @session = session
      @uid = @session.account.uid
    end
    
    def index
      collections = {}
      
      dir = @session.entry( '/Public/Vitrious' )
      dir.list.each do |element|
        if( element.directory? )
          collection = self.create_collection( element.path )
          collections[collection[:title]] = collection[:items]
        end
      end
      
      return collections
    end
    
    def create_collection( path )
      # collection = Vitrious::Collection.new( :title => File.basename( path ) )
      
      collection = {}
      collection[:title] = File.basename( path )
      collection[:items] = {}
      
      dir = @session.entry( path )
      dir.list.each do |element|
        if( File.extname( element.path ) =~ /^\.(jpg|png)$/ )
          item = self.create_item( element.path )
          collection[:items][item[:title]] = item
        end
      end
      
      return collection
    end
    
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
  end
end