require 'singleton'

module UlePage
  class PageMap
    include Singleton

    def initialize
      @map = {}
    end

    def pages
      @map
    end
  end
end