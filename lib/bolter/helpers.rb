module Bolter
  module SortHelper
    def sort_link(scope_name, text = nil, options = {})
      as = options.fetch(:as, :sorting)
      sorting = params[as] || "#{scope_name}:asc"
      current_field, direction = sorting.split(':', 2).map(&:to_s)
      direction = direction == 'asc' ? 'desc' : 'asc'
      title = text || scope
      title = title + "#{direction == 'asc' ? '&#9650;' : '&#9660;'}" if scope_name.to_s == current_field and params[as].present?
      link_to title.html_safe, url_for(params.merge(Hash[as, "#{scope_name}:#{direction}"]))
    end
  end
  module FormHelper
    def search_form(url, options = {}, &block)
      raise ArgumentError, 'Missing block' unless block_given?
      as = options.fetch(:as, :search)
      object = OpenStruct.new(params[as])
      builder = ActionView::Base.default_form_builder.new(as, object, self, options)

      html_options = options.fetch(:html, {})
      html_options[:data]   = options.delete(:data)
      html_options[:remote] = options.fetch(:remote, false)
      html_options[:method] = options.fetch(:method, :get)
      html_options[:enforce_utf8] = options.fetch(:enforce_utf8, nil)
      html_options[:authenticity_token] = options.delete(:authenticity_token)
      html_options = html_options_for_form(url, html_options)

      output = form_tag_html(html_options)
      output  << capture(builder, &block)
      output.safe_concat('</form>')
    end
  end
end
