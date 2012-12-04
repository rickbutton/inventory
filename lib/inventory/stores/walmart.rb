require 'open-uri'
require "json"


USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
module Inventory
  class Walmart
    
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
  
  def create_product_url(store_id, *upcs)
    URI::encode("https://mobile.walmart.com/m/j?service=Slap&method=get&p1=&p2=[#{upcs.join(',')}]&p3=[#{store_id}]&p4=&p5=&p6=&p7=&p8=&p9=c4tch4spyder&e=4")
  end
  def create_aisle_url(store_id, *upcs)
    URI::encode("https://mobile.walmart.com/m/j?service=AisleLocation&method=getLocationsByUPC&p1=#{store_id}&p2=[#{upcs.join(',')}]&e=1")
  end
  
  def get_products(store_id, *upcs)
    url = create_product_url(store_id, upcs)
    json = JSON.parse(open(url).read)
    products = []
    json.each do |item|
      product = {
        upc:     item["item"]["upc"].to_i,
        name:   item["item"]["name"],
        image:  item["item"]["productImageUrl"],
        stores: [],
        avg_price: 0
      }
      item["stores"].each do |store|
        product[:stores] << {
          id:       store["storeId"],
          price:    store["price"].to_f,
          in_stock: store["stockStatus"].strip == "In stock" || store["stockStatus"].strip == "Limited stock"
        }
        product[:avg_price] += store["price"].to_f
      end
      product[:avg_price] /= item["storesWithinMiles"]["availableStoresNum"].to_f
      products << product
    end
    
    aisles = get_aisles(store_id, upcs)
    products.each do |product|
      product[:aisle] = aisles[product[:upc]]
    end
        
    products
  end
  
  def get_aisles(store_id, *upcs)
    url = create_aisle_url(store_id, upcs)
    json = JSON.parse(open(url).read)
    aisles = {}
    json["locationsByUPC"].each do |product|
      aisles[product["uPC"].to_i] = product["positionData"] ? "#{product["positionData"][0]["zoneID"]}#{product["positionData"][0]["aisleID"]}" : false
    end
    aisles
  end