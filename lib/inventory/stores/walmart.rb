require 'open-uri'
require "json"
require "timeout"
require "inventory/product"

USER_AGENT = "walmart/1120 CFNetwork/548.1.4 Darwin/11.0.0"
TIMEOUT_SECS = 10
NUM_RETRIES = 2

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
    products = []
    
    Inventory.try_with_timeout(TIMEOUT_SECS, NUM_RETRIES) do
      url = create_product_url(store_id, upcs)
      json = JSON.parse(open(url, "User-Agent" => USER_AGENT).read)
      
      json.each do |item|
        product = Inventory::Product.new(
          upc:        item["item"]["upc"].to_i,
          name:       item["item"]["name"],
          image:      item["item"]["productImageUrl"],
          price:      (item["stores"][0]["price"].to_f*100).to_i,
          in_stock: item["stores"][0]["stockStatus"].strip == "In stock" || item["stores"][0]["stockStatus"].strip == "Limited stock",
          extra_properties: {
            store_code: item["stores"][0]["storeId"],
          }
        )
        products << product
      end
    end
    
    aisles = get_aisles(store_id, upcs)
    products.each do |product|
      product[:extra_properties][:aisle] = aisles[product[:upc]]
    end
    
    products

  end
  
  def get_aisles(store_id, *upcs)
    Inventory.try_with_timeout(TIMEOUT_SECS, NUM_RETRIES) do
      url = create_aisle_url(store_id, upcs)
      json = JSON.parse(open(url, "User-Agent" => USER_AGENT).read)
      aisles = {}
      json["locationsByUPC"].each do |product|
        aisles[product["uPC"].to_i] = product["positionData"] ? "#{product["positionData"][0]["zoneID"]}#{product["positionData"][0]["aisleID"]}" : nil
      end
      aisles
    end
  end