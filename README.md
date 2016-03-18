# UlePage

[![Build Status](https://travis-ci.org/jerecui/ule_page.svg?branch=master)](https://travis-ci.org/jerecui/ule_page)

Welcome to UlePage gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ule_page`. To experiment with that code, run `bin/console` for an interactive prompt.

Using UlePage, you can define page model object easily and the gem can match the current url to the specific page model with 'pg' method. e.g.
```ruby
module Page
  module Customers
    class Create < UlePage::Create
      define_elements Customer

      def add(customer)
        fill_form customer

        submit
      end
    end

    class Index < UlePage::Index
      set_urls '/customers', '/organization/:organization_id/customers'

      def has_customer?(customer)
        check_have_hashtable_content customer, [ :name, :phone, :address ]
      end

    end
  end
end

Given(/^home page has something$/) do |table|
  visit '/'
  click_link 'customers' # goto customer index pages.

  pg.has_customer? table.hashes[0] # called customer index page method.
end

```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ule_page'
```

And then execute:

  $ bundle

Or install it yourself as:

  $ gem install ule_page

## Usage
Open your features/support/env.rb, add the following lines:
```ruby
require 'ule_page'
UlePage.setup do |config|
  #add customised content
end
```
### Important:
Make sure the above lines in front of the screenshot requiring, or you can not get screenshot when you get errors.
```ruby
require 'capybara-screenshot/cucumber'
```
And in features/support/helper.rb, add lines:
```ruby
  include UlePage::Helper

```
After that, you can define your page model.

UlePage will map crud page model automatically, say, if you have a model customer defined, the four model would be added to the map.
```ruby
{
  '/customers' => Page::Customers::Index,
  '/customers/:id' => Page::Customers::Details,
  '/customers/new' => Page::Customers::Create,
  '/customers/:id/edit' => Page::Customers::Edit
}
```
If the page model is not the CRUD with simple, you can set urls manually on the page model.
```ruby
class Index < UlePage::Index
  set_urls '/orders', '/customer/:customer_id/orders'

  # ...
end

```


In cucumber step files, you can use pg.xxx, pg will get your defined model automatically via current_url.

```ruby
Given(/^home page has something$/) do
  visit '/'
  pg.has_something # you need to implement has_something method in the home_page page model.
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jerecui/ule_page.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
