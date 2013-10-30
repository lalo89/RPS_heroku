require 'rack/request'
require 'rack/response'
require 'haml'
 
module RockPaperScissors
  class App 
     def set_env(env)
      @env = env
      @session = env['rack.session']
    end

    def some_key 
      return @session['some_key'].to_i if @session['some_key']
      @session['some_key'] = 0
    end

    def some_key=(value)
      @session['some_key'] = value
    end
    
    def initialize(app = nil)
      @app = app
      @content_type = :html
      @defeat = {'rock' => 'scissors', 'paper' => 'rock', 'scissors' => 'paper'}
      @plays = {'wins' => 0, 'defeats' => 0, 'ties' => 0}
      @throws = @defeat.keys
    end

    def call(env)
      set_env(env)
      req = Rack::Request.new(env) 
      
#       req.env.keys.sort.each { |x| puts "#{x} => #{req.env[x]}" }
      
      computer_throw = @throws.sample
      player_throw = req.GET["choice"]
      answer = if !@throws.include?(player_throw)
          "Choose one of the following:"
        elsif player_throw == computer_throw
	  @plays['ties'] = @plays['ties'] + 1
          "You tied with the computer"
        elsif computer_throw == @defeat[player_throw]
	  @plays['wins'] = @plays['wins'] + 1
          "Nicely done; #{player_throw} beats #{computer_throw}"
        else
	  @plays['defeats'] = @plays['defeats'] + 1
          "Ouch; #{computer_throw} beats #{player_throw}. Better luck next time!"
        end
	
      engine = Haml::Engine.new File.open("views/index.haml").read
      
      res = Rack::Response.new
      
#       res.set_cookie("cookie_wins", {:value => @plays['wins'], :path => "/", :expire => Time.now+24*60*60})
#       res.set_cookie("cookie_defeats", {:value => @plays['defeats'], :path => "/", :expire => Time.now+24*60*60})
#       res.set_cookie("cookie_ties", {:value => @plays['ties'], :path => "/", :expire => Time.now+24*60*60})
      
      self.some_key = self.some_key + 1 if req.path == '/'
      res.write engine.render(
	{},
	:plays => @plays,
	:answer => answer,
	:throws => @throws,
        :computer_throw => computer_throw,
	:player_throw => player_throw,
	:some_key => some_key)
      res.finish
      
    end # call
  end   # App
end     # RockPaperScissors