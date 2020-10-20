require 'rails_helper'

describe 'Merchants Business Intelligence API' do
  before :each do
    @merchant1 = create(:merchant)
    item = create(:item, merchant_id: @merchant1.id)
    # ^ need to add item creation to that merchant with invoice item method in factory
    invoice = create(:invoice, merchant_id: @merchant1.id)
    invoice_item = create(:invoice_item, invoice_id: invoice.id, item_id: item.id)
    transaction = create(:transaction, invoice_id: invoice.id, result: 0)
  end

  describe 'Merchant rank by revenue' do
    xit 'sends a list of num merchants sorted in descending order by revenue' do
      get '/api/v1/merchants/most_revenue?quantity=5'


    end
  end

  describe 'Revenue for a Merchant' do
    it 'sends total collected revenue for a specific merchant' do
      get "/api/v1/merchants/#{@merchant1.id}/revenue"

      expect(response).to be_successful

      response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_key(:data)
      expect(response[:data]).to be_a(Hash)

      expect(response[:data]).to have_key(:id)
      expect(response[:data][:id]).to eq(null)

      expect(response[:data]).to have_key(:attributes)
      expect(response[:data][:attributes]).to be_a(Hash)

      expect(response[:data][:attributes]).to have_key(:revenue)
      expect(response[:data][:attributes][:revenue]).to be_a(Float)
    end
  end
end