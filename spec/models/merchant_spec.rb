require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it {should have_many :invoices}
    it {should have_many :items}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
  end

  describe 'instance methods' do
    describe 'total_revenue' do
      it 'calculates total sum of paid invoices for a merchant' do
        merchant = create(:merchant)
        item1 = create(:item, unit_price: 10, merchant_id: merchant.id)
        item2 = create(:item, unit_price: 3.99, merchant_id: merchant.id)
        item3 = create(:item, unit_price: 20.20, merchant_id: merchant.id)

        invoice1 = create(:invoice, merchant_id: merchant.id)
        invoice_item1 = create(:invoice_item, invoice_id: invoice1.id, item_id: item1.id, quantity: 5)
        invoice_item2 = create(:invoice_item, invoice_id: invoice1.id, item_id: item2.id, quantity: 10)
        transaction1 = create(:transaction, invoice_id: invoice1.id, result: 0)

        invoice2 = create(:invoice, merchant_id: merchant.id)
        invoice_item3 = create(:invoice_item, invoice_id: invoice2.id, item_id: item1.id, quantity: 1)
        transaction2 = create(:transaction, invoice_id: invoice1.id, result: 1)

        invoice3 = create(:invoice, merchant_id: merchant.id)
        invoice_item4 = create(:invoice_item, invoice_id: invoice3.id, item_id: item1.id, quantity: 10)
        invoice_item5 = create(:invoice_item, invoice_id: invoice3.id, item_id: item3.id, quantity: 1)
        transaction3 = create(:transaction, invoice_id: invoice3.id, result: 0)

        collected_revenue = (item1.unit_price * invoice_item1.quantity) + (item2.unit_price * invoice_item2.quantity) + (item1.unit_price * invoice_item4.quantity) + (item3.unit_price * invoice_item5.quantity) 

        expect(merchant.total_revenue).to eq(collected_revenue)
      end
    end
  end
end
