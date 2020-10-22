FactoryBot.define do
  factory :invoice_item do
    quantity { rand(25) }
    unit_price { Faker::Commerce.price }
    association :item
    association :invoice
  end
end
