require "ule_page/version"
require 'rails'
require 'active_record'
require 'ule_page/page_map'
require 'site_prism'

module UlePage
  autoload :Page, 'ule_page/page'
  autoload :Helper, 'ule_page/helper'
  autoload :ModelMatch, 'ule_page/model_match'
  autoload :SitePrismExtender, 'ule_page/site_prism_extender'

  autoload :Create, 'ule_page/models/create'
  autoload :Detail, 'ule_page/models/detail'
  autoload :Index, 'ule_page/models/index'


  mattr_accessor :resource_models
  @@resource_models = []

  mattr_accessor :special_maps
  @@special_maps = {}

  mattr_accessor :map
  @@map = {}

  mattr_accessor :map_initialized
  @@map_initialized = false

  mattr_accessor :module_name
  @@module_name = "Page"

  def self.setup
    UlePage::Page.send(:include, Rails.application.routes.url_helpers) if defined? Rails
    UlePage::Page.send(:include, ActionView::Helpers::NumberHelper) if defined? ActionView

    self.add_models

    yield self
  end

  def self.add_models
    if(defined? ActiveRecord::Base && defined? Rails)
      @@resource_models = Dir["#{Rails.root}/app/models/**/*.rb"].map do |m|
        m.chomp('.rb').camelize.split("::").last
      end
    end
  end
end


