module Bolter
  module Sortable
    extend ActiveSupport::Concern
    included do
      def self.sorting(sorting = nil)
        return self.order({}) unless sorting
        field, direction = sorting.split(':',2)
        if self.attribute_names.include? field.to_s
          if %W[asc desc].include? direction
            return self.reorder(Hash[field, direction])
          end
        else
          self.order({})
        end
      end
    end
  end
end
