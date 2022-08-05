class BaseController
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def index
    respond <<~HTML
      <html>
        <head><title>A Rack Demo</title></head>
        <body>
          <h1>This is the root page</h1>
          <p>Hello from a controller!</p>
        </body>
      </html>
    HTML
  end

  private

  def redirect_to(uri)
    [302, { 'Location' => uri}, []]
  end

  def respond(body, content_type: 'text/html', status: 200)
    [status, { 'Content-Type' => content_type }, [body]]
  end

  def params
    request.params
  end
end
