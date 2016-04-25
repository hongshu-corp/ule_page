require 'ule_page'

class Customer
  attr_accessor :name
  attr_accessor :age

  def attributes
    {
      "name" => "tom",
      "age" => 30
    }
  end

  def name
    MockSet.new("#customer_name")
  end

  def age
    MockSet.new("#customer_age")
  end
end

class MockSet
  def initialize(selector = nil, recorder = {})
    self.selector = selector
    self.recorder = recorder
  end

  attr_accessor :selector
  attr_accessor :recorder

  def set(*args)
    recorder[selector] = args
    args
  end

  def [](key)
    nil
  end
end

module Page
  module Customers
    class Index < UlePage::Index
      set_urls '/customers', '/admin/customers'

    end

    class Create < UlePage::Create
      define_elements Customer

    end

    class Edit < Create
    end

    class Details < UlePage::Page

    end
  end
end
