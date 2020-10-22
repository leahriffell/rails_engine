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
      # merchant 1 has revenue of $210.10 (26 items)
      @merchant1 = create(:merchant, name: 'Brandless', created_at: '2020-10-31', updated_at: '2021-01-01')
      @item1 = create(:item, unit_price: 10, merchant_id: @merchant1.id)
      @item2 = create(:item, unit_price: 3.99, merchant_id: @merchant1.id)
      @item3 = create(:item, unit_price: 20.20, merchant_id: @merchant1.id)

      invoice1 = create(:invoice, merchant_id: @merchant1.id)
      @invoice_item1 = create(:invoice_item, invoice_id: invoice1.id, item_id: @item1.id, unit_price: 10, quantity: 5)
      @invoice_item2 = create(:invoice_item, invoice_id: invoice1.id, item_id: @item2.id, unit_price: 3.99, quantity: 10)
      transaction1 = create(:transaction, invoice_id: invoice1.id, result: 0)

      invoice2 = create(:invoice, merchant_id: @merchant1.id)
      invoice_item3 = create(:invoice_item, invoice_id: invoice2.id, item_id: @item1.id, unit_price: 10, quantity: 1)
      transaction2 = create(:transaction, invoice_id: invoice1.id, result: 1)

      invoice3 = create(:invoice, merchant_id: @merchant1.id)
      @invoice_item4 = create(:invoice_item, invoice_id: invoice3.id, item_id: @item1.id, unit_price: 10, quantity: 10)
      @invoice_item5 = create(:invoice_item, invoice_id: invoice3.id, item_id: @item3.id, unit_price: 20.20, quantity: 1)
      transaction3 = create(:transaction, invoice_id: invoice3.id, result: 0)

      # merchant 2 has revenue of $600 (2 items)
      @merchant2 = create(:merchant, name: "Brand The Label", updated_at: '2021-01-01')
      @item4 = create(:item, unit_price: 300, merchant_id: @merchant2.id)
      invoice4 = create(:invoice, merchant_id: @merchant2.id)
      @invoice_item6 = create(:invoice_item, invoice_id: invoice4.id, item_id: @item4.id, unit_price: 300, quantity: 2)
      transaction4 = create(:transaction, invoice_id: invoice4.id)

      # merchant 3 has revenue of $50 (5 items)
      @merchant3 = create(:merchant, name: 'brand', created_at: '2020-10-31', updated_at: '2020-10-31')
      @item5 = create(:item, unit_price: 10, merchant_id: @merchant3.id)
      invoice5 = create(:invoice, merchant_id: @merchant3.id)
      @invoice_item7 = create(:invoice_item, invoice_id: invoice5.id, item_id: @item5.id, unit_price: 10, quantity: 5)
      transaction5 = create(:transaction, invoice_id: invoice5.id)

      # merchant 4 has revenue of $1,000.99 (1 item)
      @merchant4 = create(:merchant, name: 'Lab Store')
      @item6 = create(:item, unit_price: 1000.99, merchant_id: @merchant4.id)
      invoice6 = create(:invoice, merchant_id: @merchant4.id)
      @invoice_item8 = create(:invoice_item, invoice_id: invoice6.id, item_id: @item6.id, unit_price: 1000.99, quantity: 1)
      transaction6 = create(:transaction, invoice_id: invoice6.id)

      # merchant 5 has revenue of $50 (1 item)
      @merchant5 = create(:merchant)
      @item7 = create(:item, unit_price: 50, merchant_id: @merchant5.id)
      invoice7 = create(:invoice, merchant_id: @merchant5.id)
      @invoice_item9 = create(:invoice_item, invoice_id: invoice7.id, item_id: @item7.id, unit_price: 50, quantity: 1)
      transaction7 = create(:transaction, invoice_id: invoice7.id)

      @merchant6 = create(:merchant)
    end

    describe 'class methods' do
      describe 'single_search(attribute, value)' do
        it 'matches an exact match' do
          expect(Merchant.single_search('name', 'brand')).to eq(@merchant3)
        end

        it 'matches case insensitively' do
          expect(Merchant.single_search('name', 'Brand')).to eq(@merchant3)
        end

        it 'can find partial match' do
          expect(Merchant.single_search 'name', 'lab').to eq(@merchant2)
        end

        it 'can match based on timestamps' do
          expect(Merchant.single_search('created_at', 'October+31')).to eq(@merchant1)
  
          expect(Merchant.single_search('updated_at', '1/1/2021')).to eq(@merchant1)
        end
      end

      describe 'multi_search(attribute, value)' do
        it 'matches case insensitively' do
          expect(Merchant.multi_search('name', 'Brand')).to eq([@merchant1, @merchant2, @merchant3])
        end

        it 'can find partial match' do
          expect(Merchant.multi_search 'name', 'lab').to eq([@merchant2, @merchant4])
        end

        it 'can match based on timestamps' do
          expect(Merchant.multi_search('created_at', 'October+31')).to eq([@merchant1, @merchant3])
  
          expect(Merchant.multi_search('updated_at', '1/1/2021')).to eq([@merchant1, @merchant2])
        end
      end

      describe 'rank_by_revenue(num_limit)' do
        it 'orders merchants in descending order by revenue and limits to the top num_limit merchants' do
          expect(Merchant.rank_by_revenue(5)).to eq([@merchant4, @merchant2, @merchant1, @merchant3, @merchant5])

          # how to give merchant w/ $0 revenue default value of $0?
          # expect(Merchant.rank_by_revenue(6)).to eq([@merchant4, @merchant2, @merchant1, @merchant3, @merchant5, @merchant6])
        end
      end

      describe 'rank_by_num_items_sold(num_limit)' do
        it 'orders merchants in descending order by count of items sold and limits to the top num_limit merchants' do
          expect(Merchant.rank_by_num_items_sold(3)).to eq([@merchant1, @merchant3, @merchant2])

          expect(Merchant.rank_by_num_items_sold(5)).to eq([@merchant1, @merchant3, @merchant2, @merchant4, @merchant5])

          expect(Merchant.rank_by_num_items_sold(1)).to eq([@merchant1])

          # how to give merchant w/ 0 items sold default value of 0?
          # expect(Merchant.rank_by_num_items_sold(6)).to eq([@merchant1, @merchant3, @merchant2, @merchant4, @merchant5, @merchant6])
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
          expect(@merchant6.total_revenue).to eq(0)
        end
      end
    end
  end
end
