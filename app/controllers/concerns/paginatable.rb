require 'active_support'
require 'pagy'
require 'pagy/extras/metadata'

module Paginatable
  include Pagy::Backend
  extend ActiveSupport::Concern

  def paginate(relation, params)
    pagy(relation, page: params[:page] || 1, items: params[:count] || params[:items] || 25, size: [], count: params[:count])
  rescue Pagy::VariableError => e
    raise ArgumentError, e.message
  end

  def pagination_meta(pagy_object)
    pagy_metadata(pagy_object)
  end
end
