require 'spec_helper.rb'

describe Inventory::SamsClub do
	
	describe ".fetch" do
		it 'should return a hash that has the correct data' do
			VCR.use_cassette('fetch_multiple_valid') do
				products = Inventory::SamsClub.fetch_multiple_valid(8169,0007874213804,0088411609782)
				products.size.should == 2
				products.should =~ [Inventory::SamsClub::Product.new(:upc=>0007874213804,
					:name=>"Member's Mark Purified Bottled Water - 40 / 16.9 oz. bottles",
					:image=>"http://scene7.samsclub.com/is/image/samsclub/0007874213804_A",
					:price=>"$3.98",
					:in_stock=> true
					:sku=>"sku3314448",
					:product_id=>"prod2920474"),
				   Inventory::SamsClub::Product.new(:upc=>0088411609782,
				   	:name=>"Dell Inspiron Laptop Computer, Intel Core i7-3632QM, 8GB Memory, 1TB Hard Drive, 15.6\"",
				   	:image=>"http://scene7.samsclub.com/is/image/samsclub/0088411609782_A",
				   	:price=>"$719.00",
				   	:in_stock=> false,
				   	:sku=>"sku8924225",
				   	:product_id=>"prod8340224")
				   ]
			end
		end
	end
end
