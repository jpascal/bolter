module Bolter
  module UrlHelpers
    def sort_link(scope_name, text = nil)
      sorting = params[:sorting] || "#{scope_name}:asc"
      current_field, direction = sorting.split(':', 2).map(&:to_s)
      direction = direction == 'asc' ? 'desc' : 'asc'
      title = text || scope
      title = title + "#{direction == 'asc' ? '&#9650;' : '&#9660;'}" if scope_name.to_s == current_field and params[:sorting].present?
      link_to title.html_safe, url_for(params.merge({:sorting => "#{scope_name}:#{direction}"}))
    end
  end
  module FormHelpers
    def self.field_for_filters(name, options = {}, &block)
      record_object = OpenStruct.new(params[name])
      builder = instantiate_builder(name, record_object, options)
      silence(builder, &block)
    end
  end
end
