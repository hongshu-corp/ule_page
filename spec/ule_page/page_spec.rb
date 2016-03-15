require 'spec_helper'
require_relative '../dummy/customer_pages'

describe UlePage::Page do
  describe "page maps" do
    specify { expect(UlePage::PageMap.instance.pages.has_key? '/customers').to be_truthy }
  end
end