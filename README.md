# UlePage

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ule_page`. To experiment with that code, run `bin/console` for an interactive prompt.

Using UlePage, you can define page model object easily. e.g.
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
  end
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
end
```
And in features/support/helper.rb, add lines:
```ruby
  include UlePage::Helper

def pg
  special_maps = {
    '/' => Page::Homes::Index.new # or something eles, based on your page model
  }

  return UlePage::ModelMatch.get_current_page_with_wait special_maps
end

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
In cucumber step files, you can use pg.xxx, pg will get your defined model automatically via current_url.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jerecui/ule_page. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
