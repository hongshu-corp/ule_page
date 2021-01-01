require 'spec_helper'
require_relative '../dummy/customer_pages'

describe UlePage::Page do
  describe 'page maps' do
    specify { expect(UlePage::PageMap.instance.pages.key?('/customers')).to be_truthy }

    it 'the value should be a instance' do
      expect(UlePage::PageMap.instance.pages['/customers'].is_a?(Page::Customers::Index)).to be_truthy
    end
  end

  describe '#fill_form' do
    let(:customer) { Customer.new.attributes }
    let(:page) { Page::Customers::Create.new }
    let(:recorder) { {} }

    before do
      allow(page).to receive(:find_first).with('#customer_age').and_return(MockSet.new('#customer_age', recorder))
      allow(page).to receive(:find_first).with('#customer_name').and_return(MockSet.new('#customer_name', recorder))
    end

    it 'non specify parameter should fill all the fields' do
      page.fill_form customer
      expect(recorder.key?('#customer_name')).to be_truthy
      expect(recorder.key?('#customer_age')).to be_truthy
    end

    it 'specify parameter should only fill the specified' do
      page.fill_form customer, [:name]

      expect(recorder.key?('#customer_name')).to be_truthy
      expect(recorder.key?('#customer_age')).to be_falsy
    end

    it 'specify the mapper' do
      alias_customer = {}
      alias_customer['alias_name'] = customer['name']
      alias_customer['alias_age'] = customer['age']

      # we can use it for i18n on feature files
      # say, customer => {"名称" => 'name'}, [:name], { "名称" => "name" }
      page.fill_form customer, %i[name age], alias_name: 'name', alias_age: 'age'

      expect(recorder.key?('#customer_name')).to be_truthy
      expect(recorder.key?('#customer_age')).to be_truthy
    end
  end
end
