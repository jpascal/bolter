# Bolter

[![Gem Version](https://badge.fury.io/rb/bolter.svg)](http://badge.fury.io/rb/bolter)
[![Build Status](https://travis-ci.org/jpascal/bolter.svg?branch=master)](https://travis-ci.org/jpascal/bolter)

This gem allow you create search form and sorting in you views

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bolter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bolter

## Usage

Model:
```ruby
class Book < ActiveRecord::Base 
  include Bolter::Searchable
  include Bolter::Sortable
  scope :with_author, -> (author) {
    self.where("UPPER(author) like ?",('%'+author+'%').mb_chars.upcase)
  }
end
```

View:
```haml
.search
    = search_form books_path, id: :search do |f|
      = f.label :with_name, Book.human_attribute_name(:name)
      = f.text_field :with_name
      = f.submit 'Search'
.index
    %table
        %tr
            %th= sort_link :author, Book.human_attribute_name(:author)
        - @books.each do |book|
            %tr
                %td= book.author
```

Controller:
```ruby
class BooksController < ApplicationController
    def index
        @books = Book.search(params[:search]).sorting(params[:sorting])
    end
end
```

Using strong_parameters:
```ruby
class BooksController < ApplicationController
    def index
        @books = Book.search(search_params).sorting(params[:sorting])
    end
private
    def search_params
        params.fetch(:search, {}).permit(:with_user)
    end
end
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/jpascal/bolter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
