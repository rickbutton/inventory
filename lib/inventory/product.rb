require "virtus"

class Inventory::Product
    include Virtus
   
    attribute :upc,        Integer
    attribute :name,       String
    attribute :image,      String
    attribute :store_code, String
    attribute :price,      Integer
    attribute :in_stock,   Boolean
   
    def ==(p)
      upc == p.upc &&
      name == p.name &&
      image == p.image &&
      store_code == p.store_code &&
      price == p.price &&
      in_stock == p.in_stock
    end
    
    def to_s
      self.class.to_s + ":  " + attributes.to_s
    end
      
end