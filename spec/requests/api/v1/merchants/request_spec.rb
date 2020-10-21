require 'rails_helper'

describe 'Merchants API' do
  before :each do
    @merchant1 = merchant_with_items
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
  end

  describe 'merchants index' do
    it 'sends a list of merchants' do
      get '/api/v1/merchants'

      expect(response).to be_successful

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed[:data].count).to eq(3)

      parsed[:data].each do |merchant|
        expect(merchant).to be_a(Hash)

        expect(merchant).to have_key(:id)
        expect(merchant).to be_a(Hash)

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe 'merchant show' do
    it 'sends specific merchant' do
      get "/api/v1/merchants/#{@merchant1.id}"

      expect(response).to be_successful

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data]).to be_a(Hash)
      
      expect(parsed[:data]).to have_key(:id)
      expect(parsed[:data][:id]).to be_a(String)

      expect(parsed[:data]).to have_key(:attributes)
      expect(parsed[:data][:attributes]).to be_a(Hash)

      expect(parsed[:data][:attributes]).to have_key(:name)
      expect(parsed[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe 'create new merchant' do
    it 'can create a new merchant when all required fields are provided' do
      merchant_params = ({ name: 'The Banana Stand' })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant_params)
      created_merchant = Merchant.last

      expect(response).to be_successful
      expect(created_merchant.name).to eq(merchant_params[:name])
    end
  end

  describe 'update existing merchant' do
    it 'can update existing merchant' do
      original_name = @merchant1.name
      merchant_params = ({ name: 'Twist & Shout Records' })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/merchants/#{@merchant1.id}", headers: headers, params: JSON.generate(merchant_params)
      
      expect(response).to be_successful

      merchant = Merchant.find(@merchant1.id)
      expect(merchant.name).to_not eq(original_name)
      expect(merchant.name).to eq('Twist & Shout Records')
    end
  end

  describe 'merchant destroy' do
    it 'can destroy a merchant' do
    end
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