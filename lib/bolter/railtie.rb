require 'rails/railtie'
require 'bolter/helpers'
require 'bolter/searchable'
require 'bolter/sortable'

module Bolter
  class Railtie < Rails::Railtie
    initializer 'bolter.initialization' do
      ActiveSupport.on_load(:action_view) do
        ActionView::Base.send :include, Bolter::FormHelper
        ActionView::Base.send :include, Bolter::SortHelper
      end
    end
  end
end