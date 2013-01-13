require "spec_helper.rb"

describe Inventory::Product do
  
  it 'should have all the required fields' do
    hash = {:upc=>7239231921,
                  :name=>"Hawaiian Punch: Fruit Juicy Red Drink Mix, .74 Oz",
                  :image=>"http://i.walmartimages.com/i/p/00/07/23/92/31/0007239231921_215X215.jpg", 
                  :price=>100, 
                  :in_stock=>true,
                  :extra_properties => {
                    :store_code => "1338"
                  }}
    hash_two = {:upc=>7239231925,
                    :name=>"Jel Sert Company: Berry Blue Typhoon Low Calorie Drink Mix Sugar Free Hawaiian Punch Singles To Go, .94 oz",
                    :image=> "http://i.walmartimages.com/i/p/00/07/23/92/31/0007239231925_215X215.jpg",
                    :store_code=>"1338",
                    :price=>110, 
                    :in_stock=>false,
                    :extra_properties => {
                      :store_code => "1338",
                      :aisle=>"A13"
                    }}
    product = Inventory::Product.new(hash)
    [:upc, :name, :image, :price, :in_stock, :extra_properties].each do |field|
      product.send(field).should eq hash[field]
      product.send("#{field}=", hash_two[field])
      product.send(field).should eq hash_two[field]
    end
  end
end