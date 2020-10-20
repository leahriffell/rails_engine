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

def merchant_with_invoice_item
  FactoryBot.create(:merchant) do |merchant|
    FactoryBot.create(:invoice, merchant_id: merchant.id) do |invoice|
      FactoryBot.create(:invoice_item, invoice_id: invoice.id ) do |invoice_item|
        FactoryBot.create(:transaction, invoice_id: invoice_item.invoice_id, result: 0)
      end
    end
  end
end