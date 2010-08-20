require File.expand_path( "#{File.dirname(__FILE__)}/../test_helper" )

class VitriousAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    VitriousApp.new
  end

  def test_index
    get '/'
    assert_equal 'Hello World!', last_response.body
  end

  def test_with_params
    get '/meet', :name => 'Frank'
    assert_equal 'Hello Frank!', last_response.body
  end

  def test_with_rack_env
    get '/', {}, 'HTTP_USER_AGENT' => 'Songbird'
    assert_equal "You're using Songbird!", last_response.body
  end
end