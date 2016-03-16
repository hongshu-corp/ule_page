require 'site_prism'
require 'rspec'
require 'rspec/expectations'
require 'capybara'
require 'ule_page/site_prism_extender'
require 'ule_page/helper'
require 'ule_page/page_map'
require 'active_support/inflector'

module UlePage
  class Page < SitePrism::Page
    include Capybara::DSL
    include UlePage::Helper
    extend UlePage::SitePrismExtender
    include RSpec::Matchers

    @@urls  = []
    def self.set_urls(*urls)
      @@urls = urls
      add_to_page_map @@urls
    end

    def self.urls
      @@urls
    end

    # e.g. is_order_detail?
    def self.inherited(subclass)
      method_name = "is_#{subclass.parent.name.demodulize.singularize.underscore}_#{subclass.name.demodulize.singularize.underscore}?"
      subclass.send(:define_method, method_name) do
        true
      end
    end

    def open(expansion = {})
      self.load expansion
      self
    end

    # usage:
    # fill_form hashtable, [:id, :name], {:id => "id2"}
    # fill_form hashtable, [], {:id => "id2"}
    # fill_form hashtable
    # if the fields is empty, it will use all the keys of the hashtable
    def fill_form(hashtable, fields = [], map = {})
      fields = hashtable.keys.map { |k| k.to_sym } if fields.empty?

      fields.each do |f|
        key = f
        key = map[f] if map.has_key?(f)

        # p "setting #{f} with #{hashtable[key.to_s]}"

        send(f).send(:set, hashtable[key]) or send(f).send(:select, hashtable[key]) if self.respond_to? f.to_sym
      end
    end

    # usage:
    # check_form hashtabe, [:id, :name], {:id => "id2"}
    # check_form hashtable, [], {:id => "id2"}
    # check_form hashtable
    # if the fields is empty, it will use all the keys of the hashtable
    #
    # precondition:
    # there are the elements mapped to the hashtable keys.
    def check_form(hashtable, fields = [], map = {})
      fields = hashtable.keys.map { |k| k.to_sym } if fields.empty?

      fields.each do |f|
        key = f
        key = map[f] if map.has_key?(f)

        if self.respond_to? f.to_sym
          el_content = send(f).send(:value)

          expect(el_content).to eq hashtable[key.to_s]
        end

      end
    end

    def check_have_content(content)
      page.should have_content content
    end

    def check_have_not_content(content)
      expect(page).to have_no_content(content)
    end

    # usage: check_have_hashtable_content hashtable
    # usage: check_have_hashtable_content hashtable, [:id, :name]
    def check_have_hashtable_content(hashtable, keys = [])
      keys = hashtable.keys if keys.empty?

      keys.each do |k|
        check_have_content hashtable[k.to_s]
      end
    end

    def check_have_no_hashtable_content(hashtable, keys = [])
      keys = hashtable.keys if keys.empty?

      keys.each do |k|
        check_have_not_content hashtable[k.to_s]
      end
    end

    # usage: check_element_have_content '.nav li a', 'my brand'
    def check_element_have_content(selector, content)
      should have_selector(selector, text: content)
    end

    def check_element_have_no_content(selector, content)
      should have_no_selector(selector, text: content)
    end

    def find_row(content, rows = nil)
      rows = page.all('tr') if rows.nil?

      rows.each do |r|
        return r if r.has_content?(content)
      end
    end

    def go_back
      click_link_or_button '返回'
    end

    private
    def self.add_to_page_map(urls = [])
      urls.each {|x| PageMap.instance.pages[x] = self.new } unless urls.nil?
    end

  end
end
