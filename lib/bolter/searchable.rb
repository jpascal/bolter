module Bolter
  module Searchable
    extend ActiveSupport::Concern
    included do
      cattr_reader :filters
    end
    class_methods do
      def filter(name, value, &block)
        @@filters ||= []
        @@filters << name.to_s
        scope name.to_sym, value, &block
      end
      def search(params = {}, options = {})
        # Prepare filters
        enabled_filters = Array(options[:filters] || self.filters).map(&:to_s)

        # Prepare default result
        result = self

        # Prepare params to search
        search = (params || {}).clone.reject{|_,value| value.to_s.empty? }

        # Apply filters
        search.each do |name, value|
          if enabled_filters.include?(name.to_s)
            result = result.send(name.to_s, value)
          end
        end
        result
      end
    end
  end
end
