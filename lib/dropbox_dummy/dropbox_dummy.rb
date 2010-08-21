module Dropbox
  class Session
    def initialize(oauth_key, oauth_secret, options={})
    end
    
    def authorize_url(*args)
      return 'url'
    end
    
    def authorize(options={})
      return true
    end
    
    def authorized?
      return true
    end
    
    def serialize
      return 'serial'
    end
    
    def self.deserialize(data)
      return Dropbox::Session.new( 'oauth_key', 'oauth_secret' )
    end
    
    #################
    # API methods
    #################
    
    def download(path, options={})
      File.read( "#{Dropbox.files_root_path}/#{path}" )
    end
    
    def metadata(path, options={})
      response = <<-RESPONSE
        {
          "thumb_exists": false,
          "bytes": "#{File.size( "#{Dropbox.files_root_path}/#{path}" )}",
          "modified": "Tue, 04 Nov 2008 02:52:28 +0000",
          "path": "#{path}",
          "is_dir": "#{File.directory?( "#{Dropbox.files_root_path}/#{path}" )}",
          "size": "566.0KB",
          "root": "dropbox",
          "icon": "page_white_acrobat"
        }
      RESPONSE
      return parse_metadata(JSON.parse(response).symbolize_keys_recursively).to_struct_recursively
    end
    
    def list(path, options={})
      puts "XXX: path: #{path}"
      result = []
      
      Dir["#{Dropbox.files_root_path}/#{path}/**"].each do |element_path|
        element_path.gsub!( "#{Dropbox.files_root_path}", '' )
        entry = 
          OpenStruct.new(
            :icon => 'folder',
            :'directory?' => File.directory?( "#{Dropbox.files_root_path}/#{element_path}" ),
            :path => element_path,
            :thumb_exists => false,
            :modified => Time.parse( '2010-01-01 10:10:10' ),
            :revision => 1,
            :bytes => 0,
            :is_dir => File.directory?( "#{Dropbox.files_root_path}/#{element_path}" ),
            :size => '0 bytes'
          )
        
        puts "XXX: entry: #{entry.inspect}"
        result << entry
      end
      # list: [#<struct #<Class:0x102387270> icon="folder", :directory?=true, path="/Public/Vitrious/colección 1", thumb_exists=false, modified=Fri Aug 20 11:53:01 +0200 2010, revision=770153630, bytes=0, is_dir=true, size="0 bytes">, #<struct #<Class:0x102386118> icon="folder", :directory?=true, path="/Public/Vitrious/colección 2", thumb_exists=false, modified=Fri Aug 20 11:53:19 +0200 2010, revision=770153635, bytes=0, is_dir=true, size="0 bytes">]
    return result
    end
    
    def account
      response = <<-RESPONSE
      {
          "country": "",
          "display_name": "John Q. User",
          "quota_info": {
              "shared": 37378890,
              "quota": 62277025792,
              "normal": 263758550
          },
          "uid": "174"
      }
      RESPONSE
      
      return JSON.parse(response).symbolize_keys_recursively.to_struct_recursively
    end
  end

  
  def self.files_root_path
    return File.expand_path( "#{File.dirname(__FILE__)}/fixtures/files" )
  end
end