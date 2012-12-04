require "inventory/version"
%w(walmart).each do |store|
  require "inventory/stores/#{store}"
end

module Inventory
  class ServiceError < StandardError; end
  
  
  def self.fetch(backend, options = {})
    case backend
    when :walmart
      Inventory::Walmart.fetch(options[:store_id], options[:upcs])
    else
      raise ServiceError, "#{backend} is not a valid backend"
    end
  end
  
  
end
