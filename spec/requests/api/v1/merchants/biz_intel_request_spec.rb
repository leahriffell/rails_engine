require 'rails_helper'

describe 'Merchants Business Intelligence API' do
  before :each do
    @merchant1 = create(:merchant)
    item = create(:item, merchant_id: @merchant1.id)
    invoice = create(:invoice, merchant_id: @merchant1.id)
    invoice_item = create(:invoice_item, invoice_id: invoice.id, item_id: item.id)
    transaction = create(:transaction, invoice_id: invoice.id, result: 0)

    @merchant2 = merchant_with_invoice_item
    @merchant3 = merchant_with_invoice_item
  end

  describe 'Merchant rank by revenue' do
    it 'sends a list of num merchants sorted in descending order by revenue' do
      get '/api/v1/merchants/most_revenue?quantity=5'

      expect(response).to be_successful

      resp = JSON.parse(response.body, symbolize_names: true)

      expect(resp).to have_key(:data)
      expect(resp[:data]).to be_an(Array)

      expect(resp[:data][0]).to have_key(:id)
      expect(resp[:data][0][:id]).to be_a(String)

      expect(resp[:data][0]).to have_key(:attributes)
      expect(resp[:data][0]).to be_a(Hash)

      expect(resp[:data][0][:attributes]).to have_key(:name)
      expect(resp[:data][0][:attributes][:name]).to be_a(String)
    end
  end

  describe 'Revenue for a Merchant' do
    it 'sends total collected revenue for a specific merchant' do
      get "/api/v1/merchants/#{@merchant1.id}/revenue"

      expect(response).to be_successful

      resp = JSON.parse(response.body, symbolize_names: true)

      expect(resp).to have_key(:data)
      expect(resp[:data]).to be_a(Hash)

      # expect(resp[:data]).to have_key(:id)
      # expect(resp[:data][:id]).to eq(null)

      expect(resp[:data]).to have_key(:attributes)
      expect(resp[:data][:attributes]).to be_a(Hash)

      expect(resp[:data][:attributes]).to have_key(:revenue)
      expect(resp[:data][:attributes][:revenue]).to be_a(Float)
    end
  end

  describe 'Merchant rank by items sold' do
    it 'sends a list of num merchants sorted in descending order by revenue' do
      get '/api/v1/merchants/most_items?quantity=3'

      expect(response).to be_successful

      resp = JSON.parse(response.body, symbolize_names: true)

      expect(resp).to have_key(:data)
      expect(resp[:data].length).to eq(3)

      expect(resp[:data]).to be_an(Array)

      expect(resp[:data][0]).to have_key(:id)
      expect(resp[:data][0][:id]).to be_a(String)

      expect(resp[:data][0]).to have_key(:attributes)
      expect(resp[:data][0]).to be_a(Hash)

      expect(resp[:data][0][:attributes]).to have_key(:name)
      expect(resp[:data][0][:attributes][:name]).to be_a(String)
    end
  end
end