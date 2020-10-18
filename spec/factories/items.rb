FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Hipster.sentences(number: 1) }
    unit_price { Faker::Number.non_zero_digit }
    association :merchant_id
  end
end
