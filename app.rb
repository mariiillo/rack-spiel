require 'rack'
require 'rack/builder'
require 'rack/server'

# Class that defines the Rack app
class HelloWorldApp
  def self.call(_env)
    response = Rack::Response.new
    response.write 'Hello World 2' # write some content to the body
    response.body = ['Hello World 2'] # or set it directly
    response['X-Custom-Header'] = 'foo'
    response.set_cookie 'bar', 'baz'
    response.status = 202

    response.finish # return the generated triplet
  end
end

# Custom middleware that adds the HTTP_ACCEPT Header to the env.
# This is executed BEFORE HelloWorldApp app
# The response is sent to HelloWorldApp.
class EnsureJsonResponse
  def initialize(app)
    @app = app
  end

  def call(env)
    env['HTTP_ACCEPT'] = 'application/json'
    @app.call(env) # the next middleware is called.
  end
end

# Custom middleware that adds the X-Timing Header to the env.
# This is executed AFTER HelloWorldApp app.
# The response is sent to the web server.
class Timer
  def initialize(app)
    @app = app
  end

  def call(env)
    before = Time.now
    # the next middlewares are called and then
    # the Timer middleware modifies the env (which is then returned to the user)
    status, headers, body = @app.call(env)

    headers['X-Timing'] = "#{(Time.now - before) * 1000} sec"
    [status, headers, body]
  end
end

app = Rack::Builder.new do
  use Timer
  use EnsureJsonResponse
  run HelloWorldApp
end

Rack::Server.start app: app
