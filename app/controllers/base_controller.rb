require_relative '../controllers/concerns/renderable'

class BaseController
  include Renderable

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def index
  end

  private

  def params
    request.params&.deep_symbolize_keys
  end
end
