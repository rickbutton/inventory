require "inventory/version"
require "inventory/product"
require "timeout"
%w(walmart).each do |store|
  require "inventory/stores/#{store}"
end

module Inventory
  class ServiceError < StandardError; end
  
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
