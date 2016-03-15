require 'spec_helper'
require 'ule_page'

describe UlePage::PageMap do

  describe "singleton" do
    specify { expect(UlePage::PageMap.instance).to eq UlePage::PageMap.instance }

    specify {
      UlePage::PageMap.instance.pages[:a] = 0;
      expect(UlePage::PageMap.instance.pages[:a]).to eq 0
    }
  end

end
