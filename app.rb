require 'rack'
require 'rack/server'

class HelloWorld
  def response
    [ 200, { }, [ 'Hello World' ] ]
  end
end

class HelloWorldApp
  def self.call(env)
    HelloWorld.new.response
  end
end

Rack::Server.start :app => HelloWorldApp
