require 'spec_helper'
require 'active_record'
require 'bolter/searchable'
require 'bolter/sortable'

describe ActiveRecord do
  before(:all) do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
    # ActiveRecord::Base.logger = Logger.new STDOUT
    ActiveRecord::Migration.create_table :items do |t|
      t.string :name
      t.integer :value
    end
    class Item < ActiveRecord::Base
      include Bolter::Searchable
      include Bolter::Sortable
      scope :with_value, ->(value) {
        where(value: value)
      }
      scope :with_name, ->(name) {
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
    expect(Item.search({with_value: 4}).count).to eq(0)
  end
  it 'filter with value [1]' do
    expect(Item.search({with_value: [1]}).count).to eq(1)
  end
  it 'filter with value [1,2]' do
    expect(Item.search({with_value: [1,2]}).count).to eq(2)
  end
  it 'filter with value [1,2] and name "test1"' do
    expect(Item.search({with_value: [1,2], with_name: 'test1'}).count).to eq(0)
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
    result = Item.sorting('name:desc').search({with_value: [1,2]})
    expect(result.first.name).to eq('test3')
    expect(result.last.name).to eq('test2')
  end

  it 'filter value [1,3] and sort by name asc' do
    result = Item.search({with_value: [1,2]}).sorting('name:asc')
    expect(result.first.name).to eq('test2')
    expect(result.last.name).to eq('test3')
  end

end