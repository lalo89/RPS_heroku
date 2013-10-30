module Rsack
  class Server
    def call(env)
       response = Rack::Response.new
       response.write("Hola Mundo!")
       response.finish
    end
  end
end
