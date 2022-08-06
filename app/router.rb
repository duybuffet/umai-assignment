class Router
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def dispatch
    if klass = controller_class
      request.params.merge!(route_details)
      controller_instance = klass.new(request)
      action = route_details[:action]
      return controller_instance.public_send(action.to_sym) if controller_instance.respond_to?(action)
    end
    not_found
  end

  private

  def not_found(message = 'Not Found')
    [404, { 'Content-Type' => 'text/plain' }, [message]]
  end

  def route_details
    @route_details ||= begin
      resource = path_portions[0] || 'base'
      action, id = action_and_id(path_portions[1])
      { resource: resource, action: action, id: id }
    end
  end

  def action_and_id(path_portion)
    case path_portion
    when 'new'
      [:new, nil]
    when nil
      request.get? ? [:index, nil] : [:create, nil]
    else
      [:show, path_portion]
    end
  end

  def path_portions
    @path_portions ||= request.path.split('/').reject(&:empty?)
  end

  def controller_class
    controller_name = "#{route_details[:resource]&.capitalize}Controller"
    Object.const_get(controller_name) rescue nil
  end
end
