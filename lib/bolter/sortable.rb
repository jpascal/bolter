module Bolter
  module Sortable
    extend ActiveSupport::Concern
    included do
      def self.sorting(sorting)
        return self.scoped unless sorting
        field, direction = sorting.split(':',2)
        if self.attribute_names.include? field.to_s
          if %W[asc desc].include? direction
            self.scoped.order(Hash[field, direction])
          end
        else
          self.scoped
        end
      end
    end
  end
end
