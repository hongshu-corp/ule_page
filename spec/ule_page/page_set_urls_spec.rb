require 'spec_helper'
require_relative '../dummy/order_pages'

describe UlePage::Page do
  describe "should set the first_url to site_prism's url" do
    let(:order_index) { Page::Orders::Index }

    specify { expect(order_index.url).to eq '/customers/{customer_id}/orders' }
  end

  describe "equal to the first url" do
    let(:order_create) { Page::Orders::Create }
    specify { expect(order_create.url).to eq order_create.urls.first }
  end
end