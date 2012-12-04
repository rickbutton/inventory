require "spec_helper.rb"
require "pp"

describe Inventory do
  
  describe "#fetch" do
    it 'should call the correct backend' do
      BACKENDS = {:walmart => Inventory::Walmart}
      BACKENDS.each do |sym, back|
        back.stub(:fetch)
        back.should_receive(:fetch, {})
        Inventory.fetch(sym, {})
      end
    end
    it 'should throw a ServiceError when the backend symbol is invalid' do
      lambda { Inventory.fetch(:lol_not_a_backend, {}) }.should raise_error Inventory::ServiceError
    end
  end
end