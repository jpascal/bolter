require 'rails/railtie'
require 'bolter/helpers'
require 'bolter/searchable'
require 'bolter/sortable'

module Bolter
  class Railtie < Rails::Railtie
    initializer 'bolter.initialization' do
      ActiveSupport.on_load(:action_view) do
        ActionView::Base.send :include, Bolter::FormHelpers
        ActionView::Base.send :include, Bolter::UrlHelpers
      end

      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :include, Bolter::Searchable
        ActiveRecord::Base.send :include, Bolter::Sortable
      end

      if defined? ::Mongoid::Document
        ActiveSupport.on_load(:mongoid) do
          Mongoid::Document.send :include, Bolter::Searchable
          Mongoid::Document.send :include, Bolter::Sortable
        end
      end
    end
  end
end