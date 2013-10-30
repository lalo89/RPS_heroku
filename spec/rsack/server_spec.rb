require 'spec_helper'

describe RockPaperScissors::App do
       
       def server
	    Rack::MockRequest.new(Rack::Session::Cookie.new(RockPaperScissors::App.new, :key => 'rack.session', :secret => 'some_secret'))
       end
       
       context '/' do
	 
	 it "Deberia devolver 200" do
	   response = server.get('/')
	   response.status.should == 200
	 end
	 
	 it "Debería mostrar Practica 5" do 
           response = server.get('/')
           response.header == 'Practica 5'
         end
	 
       end
end