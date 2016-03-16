require 'capybara'

module UlePage
  module Helper
    def pg
      UlePage::ModelMatch.get_current_page_with_wait {}
    end

    def wait_for_ajax
      page.has_css?('.pace-small .pace-inactive')
    end

    def finished_all_ajax_requests?
      page.evaluate_script('jQuery  .active').zero?
    end

    def visit_admin_pages
      visit '/admin'
    end

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
