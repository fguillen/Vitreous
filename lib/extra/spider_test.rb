require File.expand_path( "#{File.dirname(__FILE__)}/../../test/test_helper" )
require File.expand_path( "#{File.dirname(__FILE__)}/spider" )


module Extra
  class SpiderTest < Test::Unit::TestCase
    def test_create_tree_from_mintegi_dot_com
      Extra::Spider.create_tree_from_mintegi_dot_com
    end
    
    def test_digest_structure
      Extra::Spider.digest_structure
    end
  end
end