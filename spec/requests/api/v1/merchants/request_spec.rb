require 'rails_helper'

describe 'Merchants API' do
  before :each do
    @merchant1 = merchant_with_items
  end

  describe 'merchant items' do
    it 'sends all items for a specific merchant' do
      get "/api/v1/merchants/#{@merchant1.id}/items"

      expect(response).to be_successful

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed[:data].count).to eq(5)  

      expect(parsed).to have_key(:data)
      expect(parsed[:data]).to be_an(Array)

      expect(parsed[:data][0]).to be_a(Hash)

      expect(parsed[:data][0]).to have_key(:id)
      expect(parsed[:data][0][:id]).to be_a(String)
    end
  end
end