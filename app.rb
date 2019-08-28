require 'rack'
require 'rack/server'

class HelloWorldApp
  def self.call(env)
    response = Rack::Response.new
    response.write 'Hello World 2'      # write some content to the body
    response.body = [ 'Hello World 2' ] # or set it directly
    response['X-Custom-Header'] = 'foo'
    response.set_cookie 'bar', 'baz'
    response.status = 202

    response.finish # return the generated triplet
  end
end

Rack::Server.start app: HelloWorldApp
