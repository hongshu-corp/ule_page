require 'ule_page'

module Page
  module Orders
    class Index < UlePage::Index
      set_urls '/customers/:customer_id/orders', '/orders'
    end

    class Create < UlePage::Create
      set_urls '/orders/new'
    end

    class Edit < Create
    end

    class Details < UlePage::Page
    end
  end
end
