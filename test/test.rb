require "test/unit"
require "rsack"
require "rack/test"
require "pp"

class RPSApp_Test < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Rack::Builder.new do
      use(Rack::Session::Cookie, {:key => 'rack.session', :secret => 'some_secret'})
      run RockPaperScissors::App.new
    end.to_app
  end
   
  def test_index
    get "/"
    assert last_response.ok?
  end
  
  def test_rock
    get "/?choice=rock"
    assert last_response.ok?
  end
  
  def test_paper
    get "/?choice=paper"
    assert last_response.ok?
  end
  
  def test_scissors
    get "/?choice=scissors"
    assert last_response.ok?
#     pp last_response
  end
  
  def test_body
    get "/"
    assert last_response.body.include? ("Rock, Paper and Scissors")
  end
end