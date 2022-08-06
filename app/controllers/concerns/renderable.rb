require 'active_support'
require_relative 'paginatable'

module Renderable
  extend ActiveSupport::Concern

  included do
    include Paginatable
  end

  def render_resources(resources, params = {}, options = {})
    serializer_class = options[:each_serializer] || "#{resources.ancestors.first.name}Serializer".constantize
    pagy, records = paginate(resources, params)

    serializer_options = options.slice(*accepted_jsonapi_serializer_options).merge(is_collection: true)
    serializer_options[:meta] = (serializer_options[:meta] || {}).merge(pagination_meta(pagy))

    respond(serializer_class.new(records, serializer_options).serializable_hash.to_json, 'application/json', options[:status] || 200)
  end

  def render_resource(resource, options = {})
    serializer_class = options[:serializer] || "#{resource.class.name}Serializer".constantize
    serializer_options = options.slice(*accepted_jsonapi_serializer_options).merge(is_collection: false)

    respond(serializer_class.new(resource, serializer_options).serializable_hash.to_json, 'application/json', options[:status] || 200)
  end

  def respond(body, content_type = 'application/json', status = 200)
    [status, { 'Content-Type' => content_type }, [body]]
  end

  def render_errors(errors, options = {})
    respond(errors.to_json, 'application/json', options[:status] || 422)
  end

  private

  def accepted_jsonapi_serializer_options
    %i[meta links include params]
  end
end
