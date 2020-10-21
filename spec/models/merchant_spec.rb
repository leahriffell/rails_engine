require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it {should have_many :invoices}
    it {should have_many :items}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
  end

  describe 'methods' do
    before :each do
      # merchant 1 has revenue of $210.10
      @merchant1 = create(:merchant)
      @item1 = create(:item, unit_price: 10, merchant_id: @merchant1.id)
      @item2 = create(:item, unit_price: 3.99, merchant_id: @merchant1.id)
      @item3 = create(:item, unit_price: 20.20, merchant_id: @merchant1.id)

      invoice1 = create(:invoice, merchant_id: @merchant1.id)
      @invoice_item1 = create(:invoice_item, invoice_id: invoice1.id, item_id: @item1.id, quantity: 5)
      @invoice_item2 = create(:invoice_item, invoice_id: invoice1.id, item_id: @item2.id, quantity: 10)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 0)

      invoice2 = create(:invoice, merchant_id: @merchant1.id)
      invoice_item3 = create(:invoice_item, invoice_id: invoice2.id, item_id: @item1.id, quantity: 1)
      transaction2 = create(:transaction, invoice_id: invoice1.id, result: 1)

      invoice3 = create(:invoice, merchant_id: @merchant1.id)
      @invoice_item4 = create(:invoice_item, invoice_id: invoice3.id, item_id: @item1.id, quantity: 10)
      @invoice_item5 = create(:invoice_item, invoice_id: invoice3.id, item_id: @item3.id, quantity: 1)
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 0)

      # merchant 2 has revenue of $600
      @merchant2 = create(:merchant)
      @item4 = create(:item, unit_price: 300, merchant_id: @merchant2.id)
      invoice4 = create(:invoice, merchant_id: @merchant2.id)
      @invoice_item6 = create(:invoice_item, invoice_id: invoice4.id, item_id: @item4.id, quantity: 2)
      transaction4 = create(:transaction, invoice_id: invoice4.id)

      # merchant 3 has revenue of $50
      @merchant3 = create(:merchant)
      @item5 = create(:item, unit_price: 10, merchant_id: @merchant3.id)
      invoice5 = create(:invoice, merchant_id: @merchant3.id)
      @invoice_item7 = create(:invoice_item, invoice_id: invoice5.id, item_id: @item5.id, quantity: 5)
      transaction5 = create(:transaction, invoice_id: invoice5.id)

      # merchant 4 has revenue of $1,000.99
      @merchant4 = create(:merchant)
      @item6 = create(:item, unit_price: 1000.99, merchant_id: @merchant4.id)
      invoice6 = create(:invoice, merchant_id: @merchant4.id)
      @invoice_item8 = create(:invoice_item, invoice_id: invoice6.id, item_id: @item6.id, quantity: 1)
      transaction6 = create(:transaction, invoice_id: invoice6.id)

      # merchant 5 has revenue of $50
      @merchant5 = create(:merchant)
      @item7 = create(:item, unit_price: 50, merchant_id: @merchant5.id)
      invoice7 = create(:invoice, merchant_id: @merchant5.id)
      @invoice_item9 = create(:invoice_item, invoice_id: invoice7.id, item_id: @item7.id, quantity: 1)
      transaction7 = create(:transaction, invoice_id: invoice7.id)
    end

    describe 'class methods' do
      describe 'rank_by_revenue(num_limit)' do
        it 'orders merchants in descending order by revenue and limits to the top num_limit' do
          results = Merchant.rank_by_revenue(5)

          expect(results[0][0]).to eq(@merchant4.id)
          expect(results[1][0]).to eq(@merchant2.id)
          expect(results[2][0]).to eq(@merchant1.id)
          expect(results[3][0]).to eq(@merchant5.id)
          expect(results[4][0]).to eq(@merchant3.id)
        end
      end
    end

    describe 'instance methods' do
      describe 'total_revenue' do
        it 'calculates total sum of paid invoices for a merchant' do
          expect(@merchant1.total_revenue).to eq(210.10)
          expect(@merchant2.total_revenue).to eq(600)
          expect(@merchant3.total_revenue).to eq(50)
          expect(@merchant4.total_revenue).to eq(1000.99)
          expect(@merchant5.total_revenue).to eq(50)
          # expect(@merchant6.total_revenue).to eq(0)
        end
      end
    end
  end
end
