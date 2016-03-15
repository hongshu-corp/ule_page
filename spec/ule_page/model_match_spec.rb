require 'spec_helper'
require_relative '../dummy/customer_pages'

describe UlePage::ModelMatch do
  describe "#get_model" do
    let(:map) {
      {
        '/customers/new' => Page::Customers::Create,
        '/admin/customers/:id/edit' => Page::Customers::Edit
      }
    }

    it 'exact match' do
      expect(UlePage::ModelMatch.get_model(map, '/customers/new')).to eq Page::Customers::Create
    end

    it 'regex match' do
      expect(UlePage::ModelMatch.get_model(map, '/admin/customers/3/edit')).to eq Page::Customers::Edit
    end

    it 'no match' do
      expect(UlePage::ModelMatch.get_model(map, '/admin/customers/new')).to be_nil
    end
  end

  describe "#prepare_maps" do
    let(:special_maps) { {} }
    subject { UlePage::ModelMatch.prepare_maps special_maps}
    describe "convention maps" do
      before { UlePage.resource_models = [ 'Customer'] }
      it 'should have the convention pages' do
        expect(subject.has_key? '/customers').to be_truthy
        expect(subject.has_key? '/customers/new').to be_truthy
        expect(subject.has_key? '/customers/:id/edit').to be_truthy
        expect(subject.has_key? '/customers/:id').to be_truthy
      end
    end
    describe "should merged the customer's set_urls path" do
      specify {
        expect(subject.has_key? '/customers').to be_truthy
        expect(subject.has_key? '/admin/customers').to be_truthy
      }
    end
  end

end
