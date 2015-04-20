module Bolter
  module Searchable
    extend ActiveSupport::Concern
    included do
      cattr_reader :filters
      def self.filter(name, value, &block)
        @@filters ||= []
        @@filters << name.to_s
        scope name.to_sym, value, &block
      end
      # options[:filters] - used filters, default for all
      def self.search(params = {}, options = {})
        # Prepare filters
        filters = Array(options[:filters] || self.filters).map(&:to_s)

        # Prepare default result
        result = self.scoped

        # Prepare params to search
        search = (params || {}).clone.reject{|_,value| value.to_s.empty? }

        # Apply filters
        search.each do |name, value|
          if self.scopes.include? name.to_sym
            if filters.include? name.to_s
              result = self.scopes[name.to_sym][:scope].arity == 0 ? result.send(name) : result.send(name, *value)
            else
              logger.warn "Skip filter #{self}.#{name}(#{value.inspect})"
            end
          else
            logger.warn "Unknown filter #{self}.#{name}(#{value.inspect})"
          end
        end

        # return scope with applied filters
        return result
      end
    end
  end
end
