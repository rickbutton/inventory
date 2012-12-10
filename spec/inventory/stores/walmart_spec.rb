require "spec_helper.rb"

describe Inventory::Walmart do
  
  describe Inventory::Walmart::Product do
    it 'should have an aisle field' do
      hash = {:upc=>7239231921,
        :name=>"Hawaiian Punch: Fruit Juicy Red Drink Mix, .74 Oz",
        :image=>"http://i.walmartimages.com/i/p/00/07/23/92/31/0007239231921_215X215.jpg",
        :store_code=>"2339", 
        :price=>100, 
        :in_stock=>true,
        :aisle=>"A14"}
      lambda {
        p = Inventory::Walmart::Product.new(hash)
        p.aisle.should eq "A14"
      }.should_not raise_error
    end
  end

  describe ".fetch" do
    it 'should return a hash that has the correct data' do
      VCR.use_cassette('fetch_multiple_valid') do
        products = Inventory::Walmart.fetch(2339, 7239231925, 7239231921)
        products.size.should == 2
        products.should =~ [Inventory::Walmart::Product.new(:upc=>7239231921,
                      :name=>"Hawaiian Punch: Fruit Juicy Red Drink Mix, .74 Oz",
                      :image=>"http://i.walmartimages.com/i/p/00/07/23/92/31/0007239231921_215X215.jpg",
                      :store_code=>"2339", 
                      :price=>100, 
                      :in_stock=>true,
                      :aisle=>"A14"),
                     
                     Inventory::Walmart::Product.new(:upc=>7239231925,
                      :name=>"Jel Sert Company: Berry Blue Typhoon Low Calorie Drink Mix Sugar Free Hawaiian Punch Singles To Go, .94 oz",
                      :image=> "http://i.walmartimages.com/i/p/00/07/23/92/31/0007239231925_215X215.jpg",
                      :store_code=>"2339",
                      :price=>100, 
                      :in_stock=>true,
                      :aisle=>"A14")
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
        products[1][:aisle].should be_nil
      end
    end
    it 'should make service calls with a timeout' do
      VCR.use_cassette("fetch_multiple_valid") do
        Inventory.should_receive(:try_with_timeout).twice
        products = Inventory::Walmart.fetch(2339, 7239231925, 7239231921)
      end
    end
  end
end