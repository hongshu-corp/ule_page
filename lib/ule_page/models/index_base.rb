require 'ule_page/page'

module UlePage
  class IndexBase < Base
    element_collection :rows, 'tbody tr'

    def goto_edit
      click_link_or_button '编辑'
    end

    protected
    def key_column
      ""
    end

    def get_row key
      find_row key, self.rows
    end

    def get_model_row model
      find_row(model[key_column], self.rows)
    end

    def get_model_row_anchor model, link_text
      row = get_model_row(model)
      raise 'can not find the row' if row.nil?
      row.find(:link_or_button, link_text)
    end
  end
end