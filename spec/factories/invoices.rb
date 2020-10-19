FactoryBot.define do
  factory :invoice do
    status { 0 }
    association :customer_id
    association :merchant_id
  end
end
