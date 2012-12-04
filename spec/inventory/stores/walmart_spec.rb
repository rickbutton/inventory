require "spec_helper.rb"
require "pp"

describe Inventory::Walmart do

  describe "#fetch" do
    it 'should return a hash that has the correct data' do
      VCR.use_cassette('fetch_multiple_valid') do
        products = Inventory::Walmart.fetch(2339, 7239231925, 7239231921)
        products.size.should == 2
        products.should =~ [{:upc=>7239231921,
                      :name=>"Hawaiian Punch: Fruit Juicy Red Drink Mix, .74 Oz",
                      :image=>"http://i.walmartimages.com/i/p/00/07/23/92/31/0007239231921_215X215.jpg",
                      :stores=>[{:id=>"2339", :price=>1.0, :in_stock=>true}],
                      :avg_price=>1.0,
                      :aisle=>"A14"},
                     
                     {:upc=>7239231925,
                      :name=>"Jel Sert Company: Berry Blue Typhoon Low Calorie Drink Mix Sugar Free Hawaiian Punch Singles To Go, .94 oz",
                      :image=> "http://i.walmartimages.com/i/p/00/07/23/92/31/0007239231925_215X215.jpg",
                      :stores=>[{:id=>"2339", :price=>1.0, :in_stock=>true}],
                      :avg_price=>1.0,
                      :aisle=>"A14"}
                    ]
      end
    end
    it 'should throw an error when there are no upcs' do
      lambda { Inventory::Walmart.fetch(2339) }.should raise_error(ArgumentError)
    end
    it 'should throw an error when an argument is invalid' do
      VCR.use_cassette("fetch_invalid") do
        lambda { Inventory::Walmart.fetch(1, 123)}.should raise_error(Inventory::ServiceError)
      end
    end
    it 'should have aisle:false for products without aisle information' do
      VCR.use_cassette("fetch_no_aisle_valid") do
        products = Inventory::Walmart.fetch(2339, 7239231925, 7239231921)
        products[1][:aisle].should be_false
      end
    end
  end
end