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
      attributes == p.attributes
    end
    
    def to_s
      self.class.to_s + ":  " + attributes.to_s
    end
      
end