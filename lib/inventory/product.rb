require "virtus"

class Inventory::Product
    include Virtus
   
    attribute :upc,        Integer
    attribute :name,       String
    attribute :image,      String
    attribute :price,      Integer
    attribute :in_stock,   Boolean
    
    attribute :extra_properties, Hash
    
    def initialize(attrs = nil)
      attrs[:extra_properties] = attrs[:extra_properties].clone if attrs && attrs[:extra_properties]
      super(attrs)
    end
   
    def ==(p)
      attributes == p.attributes
    end
    
    def to_s
      self.class.to_s + ":  " + attributes.to_s
    end
      
end