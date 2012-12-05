require "inventory/version"
require "timeout"
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
  
  def self.try_with_timeout(secs, retries)
    begin
      Timeout::timeout(secs) do
        yield
      end
    rescue Timeout::Error => e
      retries -= 1
      if retries > 0
        retry
      else
        raise ServiceError, "Service timed out: #{e.inspect}"
      end
    end
  end
  
  
end
