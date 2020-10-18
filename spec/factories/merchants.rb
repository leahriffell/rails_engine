FactoryBot.define do
  factory :merchant do
    name { Faker::Hipster.words(number: 2) }
  end
end

def merchant_with_items(item_count: 5)
  FactoryBot.create(:merchant) do |merchant|
    FactoryBot.create_list(:item, item_count, merchant_id: merchant.id)
  end
end