FactoryBot.define do
  factory :transaction do
    association :invoice
    credit_card_number { Faker::Finance.credit_card }
    credit_card_expiration_date { nil }
    result { rand(1) }
  end
end