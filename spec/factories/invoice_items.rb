FactoryBot.define do
  factory :invoice_item do
    quantity { rand(25) }
    association :item
    association :invoice
  end
end
