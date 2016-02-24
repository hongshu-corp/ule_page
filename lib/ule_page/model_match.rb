require 'capybara'
require 'site_prism'

module UlePage
  module ModelMatch

    class << self
      include Capybara::DSL
      def get_current_page_with_wait(special_maps = {})
        page.has_css?('.pace-small .pace-inactive') if defined? page

        current = get_current_page special_maps

        if !current_path.nil? && current.nil?
          p "current path is #{current_path}, we can not get the page model, please add it to the get_current_page map. (helper.rb)"

          raise
        end

        current
      end

      def get_current_page(special_maps = {})
        resources = UlePage.resource_models || []

        if !UlePage.map_initialized || UlePage.special_maps.empty?
          UlePage.special_maps = special_maps
          UlePage.map = UlePage.special_maps

          # => to generate the following
          # '/customers' => Page::Customers::Index.new,
          # '/customers/new' => Page::Customers::Create.new,
          # '/customers/:id' => Page::Customers::Details.new,
          # '/customers/:id/edit' => Page::Customers::Edit.new,
          resources.each do |model|

            pluralized = model.to_s.underscore.pluralize
            page_module_name = model.to_s.pluralize.camelize

            next unless Object.const_defined?("#{UlePage.module_name}::#{page_module_name}")

            page_module = Object.const_get(UlePage.module_name).const_get(page_module_name)
            UlePage.map["/#{pluralized}"] = page_module.const_get("Index").try(:new) rescue false
            UlePage.map["/#{pluralized}/new"] = page_module.const_get("Create").new rescue false
            UlePage.map["/#{pluralized}/:id"] = page_module.const_get("Details").new rescue false
            UlePage.map["/#{pluralized}/:id/edit"] = page_module.const_get("Edit").new rescue false
          end

          UlePage.map_initialized = true
        end

        map = UlePage.map
        return nil unless current_path

        current = get_model map, current_path

        if current.nil? && current_path.include?('/admin/')
          current =  get_model map, current_path[6, current_path.length]
        end

        current
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
    end
  end
end