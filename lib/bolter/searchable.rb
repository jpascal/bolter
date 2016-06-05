module Bolter
  module Searchable
    extend ActiveSupport::Concern
    included do
      cattr_reader :used_as_filters
      def self.search(params = {}, options = {})
        result = self.current_scope || self
        # Prepare params to search
        search = (params || {}).clone.reject{|_,value| value.to_s.empty? }
        # Apply filters
        search.each do |name, value|
          result = result.send(name.to_s, value) if result.respond_to? name.to_s
        end
        result
      end
    end
  end
end
