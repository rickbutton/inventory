require 'open-uri'
require "json"
require "timeout"
require "inventory/product"

USER_AGENT = "Dalvik/1.6.0 (Linux; U; Android 4.2.1; Galaxy Nexus Build/JOP40D)"
TIMEOUT_SECS = 5
NUM_RETRIES = 2

module Inventory
  class SamsClub
    
    class Product < Inventory::Product
            
    end
    
    def self.fetch(store_id, *upcs)
      raise ArgumentError, "You must pass at least one UPC code into the fetch method" if upcs.empty?
      begin
        get_products(store_id, upcs)
      rescue OpenURI::HTTPError => e
        raise Inventory::ServiceError, "There was an error processing the request. This usually means that there was bad input (invalid store code or UPC): #{e.message}"
      end
    end
    
  end
end

private
  
  def get_nearby_stores(latt,longg)
    URI::encode("http://www3.samsclub.com/Services/Club/NearLatLong/#{latt},#{longg}/50.0/?loadEvents=true&loadSchedules=true&loadServices=true")
  end  #/Services/Club/NearAddress/47906/50.0/?loadEvents=true%Loa...(same as above)

  def get_nearest_store(json)
    json['clubs'][0]['cn']
  end

  def create_product_url(store_id, upc)
    URI::encode("http://mobility.samsclub.com/jsonsrv/searchRequest.jsp?txt=&upc=#{upc}&clubId=#{store_id}&catId=rootCategory&cnpApp=false&pageNum=1&pageSize=15&filter=all&sortBy=2&sortDirection=0 HTTP/1.1")
  end

  def get_products(store_id, *upcs)
    products = []
    
    Inventory.try_with_timeout(TIMEOUT_SECS, NUM_RETRIES) do
      
      upcs.each do |item|
        url = get_item_info(store_id,item)
        json = JSON.parse(open(url, "User-Agent" => USER_AGENT).read)
        product = Inventory::SamsClub::Product.new(
          upc:        json["upc"]
          name:       json["p"][0]["n"]
          image:      json["p"][0]["sa"][0]["li"]
          price:      json["p"][0]["ip"]
          in_stock:   (json["p"][0]["ip"] != "").to_s
          sku:        json["p"][0]["sa"][0]["id"]
          product_id: json["p"][0]["prodid"]
        )
        products << product
      end
    end
   
    products

end