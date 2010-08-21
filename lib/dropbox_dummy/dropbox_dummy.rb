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
    
    module Api
      def download(path, options={})
        File.read( "#{Dropbox.files_root_path}/#{path}" )
      end
      
      def metadata(path, options={})
        result = {
          "thumb_exists": false,
          "bytes": File.size( "#{Dropbox.files_root_path}/#{path}" ),
          "modified": "Tue, 04 Nov 2008 02:52:28 +0000",
          "path": path,
          "is_dir": File.directory?( "#{Dropbox.files_root_path}/#{path}" ),
          "size": "566.0KB",
          "root": "dropbox",
          "icon": "page_white_acrobat"
        }
          
        return parse_metadata(result).to_struct_recursively
      end
      
      def list(path, options={})
        metadata(path, options.merge(:suppress_list => false)).contents
      end
    end
  end
  
  def self.files_root_path
    return "#{File.dirname(__FILE__)}/fixtures/files"
  end
end