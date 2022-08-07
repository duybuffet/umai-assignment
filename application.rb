require 'pry'

app_files = File.expand_path('../app/**/*.rb', __FILE__)
Dir.glob(app_files).each { |file| require(file) }

class Application
  def call(env)
    serve_request(Rack::Request.new(env))
  end

  def serve_request(req)
    Router.new(req).dispatch
  end
end
