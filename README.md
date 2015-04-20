# Bolter

[![Gem Version](https://badge.fury.io/rb/bolter.svg)](http://badge.fury.io/rb/bolter)

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
  filter :with_author, -> (author) {
    self.where("author like ?",author)
  }
end
```

View:
```haml
.search
    = form_tag books_path, method: :get, id: :search do
        = fields_for :filters, OpenStruct.new(params[:filters]) do |f|
            = f.label :with_name, EventTarget.human_attribute_name(:name)
            = f.text_field :with_name, :class => 'form-control'
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
@books = Book.search(params[:filters]).sorting(params[:sorting])
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
