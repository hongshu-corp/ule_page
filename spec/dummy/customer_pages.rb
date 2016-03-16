require 'ule_page'

module Page
  module Customers
    class Index < UlePage::Index
      set_urls '/customers', '/admin/customers'

    end

    class Create < UlePage::Create

    end

    class Edit < Create
    end

    class Details < UlePage::Page

    end
  end
end
