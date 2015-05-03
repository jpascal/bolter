require 'spec_helper'
require 'mongoid'
require 'bolter/searchable'
require 'bolter/sortable'

describe Mongoid do
  before(:all) do
    Mongoid.load!('./spec/config/mongoid.yml', :development)
    Mongoid.purge!
    class Item
      include Mongoid::Document
      include Bolter::Searchable
      include Bolter::Sortable

      field :name, type: String
      field :value, type: Integer

      filter :search_value, ->(value) {
        if value.is_a? Array
          self.in({value: value})
        else
          where(value: value)
        end
      }
      filter :search_name, ->(name) {
        where(name: name)
      }
    end
    Item.create!([
      { name: 'test1', value: 3 },
      { name: 'test2', value: 2 },
      { name: 'test3', value: 1 }
    ]);
  end
  it 'filter with value 4' do
    expect(Item.search({search_value: 4}).count).to eq(0)
  end
  it 'filter with value [1]' do
    expect(Item.search({search_value: [1]}).count).to eq(1)
  end
  it 'filter with value [1,2]' do
    expect(Item.search({search_value: [1,2]}).count).to eq(2)
  end
  it 'filter with value [1,2] and name "test1"' do
    expect(Item.search({search_value: [1,2], search_name: 'test1'}).count).to eq(0)
  end
  it 'sort by name asc' do
    result = Item.sorting('name:asc')
    expect(result.first.name).to eq('test1')
    expect(result.last.name).to eq('test3')
  end

  it 'sort by name desc' do
    result = Item.sorting('name:desc')
    expect(result.first.name).to eq('test3')
    expect(result.last.name).to eq('test1')
  end

  it 'sort by name desc and filter value [1,3]' do
    result = Item.sorting('name:desc').search({search_value: [1,2]})
    expect(result.first.name).to eq('test3')
    expect(result.last.name).to eq('test2')
  end

  it 'filter value [1,3] and sort by name asc' do
    result = Item.search({search_value: [1,2]}).sorting('name:asc')
    expect(result.first.name).to eq('test2')
    expect(result.last.name).to eq('test3')
  end
end