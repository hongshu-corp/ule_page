require 'ule_page/page'

module UlePage
  class CreateBase < Base
    element :create_button, 'input[type="submit"]'

    def submit
      self.create_button.click
    end
  end
end