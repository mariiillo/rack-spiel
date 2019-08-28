require 'rack'
require 'rack/builder'
require 'rack/etag'
require 'rack/conditional_get'
require 'rack/deflater'
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

app = Rack::Builder.new do
  use Rack::ETag
  use Rack::ConditionalGet
  use Rack::Deflater
  run HelloWorldApp
end

Rack::Server.start app: app
