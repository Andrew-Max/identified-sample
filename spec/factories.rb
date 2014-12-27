FactoryGirl.define do

  factory :clearance_batch do

  end

  factory :item do
    style
    clearance_batch
    color "Blue"
    size "M"
    status "sellable"
    price_sold 23
  end

  factory :style do
    type "Pants"
    wholesale_price 55
  end
end
