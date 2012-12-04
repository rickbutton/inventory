# Inventory

Inventory is a gem that allows you to programmatically access retail store stock information. In the future it will support multiple stores, but for now it only supports Walmart.

## Installation

Add this line to your application's Gemfile:

    gem 'inventory'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inventory

## Usage

### Walmart

1. Find the store's id code. (Using store number 2339 in this example)
2. Find the UPCs of the products you want to check. (Using 7239231921 in this example).

```
Inventory.fetch(:walmart, store_id: 2339, upcs: [7239231921])

=> [
    {
     :upc=>7239231921,
     :name=>"Hawaiian Punch: Fruit Juicy Red Drink Mix, .74 Oz",
     :image=>"http://i.walmartimages.com/i/p/00/07/23/92/31/0007239231921_215X215.jpg",
     :stores=>[{:id=>"2339", :price=>1.0, :in_stock=>true}],
     :avg_price=>1.0,
     :aisle=>"A14"
    }
   ]
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
