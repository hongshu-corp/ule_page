require 'capybara'

module UlePage
  module Helper
    def get_current_page_with_wait
      page.has_css?('.pace-small .pace-inactive')

      current = get_current_page

      if !current_path.nil? && current.nil?
        p "current path is #{current_path}, we can not get the page model, please add it to the get_current_page map. (helper.rb)"

        raise
      end

      current
    end

    alias pg get_current_page_with_wait

    @@map = {}
    @@map_initialized = false

    def get_current_page
      resources = [Customer, Contract, Category, Discount, Order, OrderTransfer, Detect, SamplingSite, Salesman]
      resources += [Product, User, Serial, Receiver, ShippingFreezer, Accountant]
      resources += ['OrganizationUser', Organization, ShortMessage, Settlement]
      resources += [Allinpay, Consultant]


      unless @@map_initialized
        @@map = get_special_maps

        # => to generate the following
        # '/customers' => Page::Customers::Index.new,
        # '/customers/new' => Page::Customers::Create.new,
        # '/customers/:id' => Page::Customers::Details.new,
        # '/customers/:id/edit' => Page::Customers::Edit.new,
        resources.each do |model|
          pluralized = model.to_s.underscore.pluralize
          page_module_name = model.to_s.pluralize.camelize
          page_module = Object.const_get("Page").const_get(page_module_name)
          @@map["/#{pluralized}"] = page_module.const_get("Index").try(:new)
          @@map["/#{pluralized}/new"] = page_module.const_get("Create").new rescue false
          @@map["/#{pluralized}/:id"] = page_module.const_get("Details").new rescue false
          @@map["/#{pluralized}/:id/edit"] = page_module.const_get("Edit").new rescue false
        end
        @@map_initialized = true
      end

      map = @@map

      return nil unless current_path

      current = get_model map, current_path

      if current.nil? && current_path.include?('/admin/')
        current =  get_model map, current_path[6, current_path.length]
      end

      current
    end

    def get_special_maps
      { }
    end

    def get_model(map, path)
      map[path] || try_regex_match(map, path)
    end

    def try_regex_match(map, path)
      map.each do |k, v|
        pattern = k
        pattern = k.gsub(/(:\w+)/, '\w+') if k.include?(':')

        regex = Regexp.new "^#{pattern}$"
        if regex.match(path)
          return v
        end
      end

      nil
    end

    def wait_for_ajax
      page.has_css?('.pace-small .pace-inactive')
      # Timeout.timeout(Capybara.default_wait_time) do
      #   loop until finished_all_ajax_requests?
      # end
    end

    def finished_all_ajax_requests?
      page.evaluate_script('jQuery  .active').zero?
    end

    def create_wechat_user
      user = FactoryGirl.build(:wechat_user)
      user.save validate: false

      user
    end

    # def signin(user)
    #   token = User.new_remember_token

    #   if need_run_javascript
    #     if Capybara.current_driver == :selenium
    #       visit_admin_pages
    #       page.driver.browser.manage.delete_all_cookies
    #       Capybara.current_session.driver.browser.manage.add_cookie :name => 'remember_token', :value => token
    #     else
    #       page.driver.set_cookie("remember_token", token)
    #     end
    #   else
    #     Capybara.current_session.driver.browser.set_cookie("remember_token=#{token}")
    #   end

    #   user.update_attribute(:remember_token, User.encrypt(token))
    # end

    def signout
      browser = Capybara.current_session.driver.browser
      if need_run_javascript
        if Capybara.current_driver == :selenium
          visit_admin_pages
          browser.manage.delete_all_cookies
        else
          page.driver.set_cookie("remember_token", '')
        end
      else
        if browser.respond_to?(:clear_cookies)
          # Rack::MockSession
          browser.clear_cookies
        else
          Capybara.current_session.driver.browser.set_cookie("remember_token=")
        end
      end
    end

    def visit_admin_pages
      visit '/admin'
    end

    def need_run_javascript
      Capybara.current_driver == :selenium or Capybara.current_driver == Capybara.javascript_driver
    end

    def confirm_alert
      if page.driver.class == Capybara::Selenium::Driver
        page.driver.browser.switch_to.alert.accept
      elsif page.driver.class == Capybara::Webkit::Driver
        sleep 1 # prevent test from failing by waiting for popup
        page.driver.browser.accept_js_confirms
      else
        p "pressed ok"
      end
    end

    def pause_here
      STDIN.getc
    end
  end
end
