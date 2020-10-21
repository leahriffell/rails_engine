require 'rails_helper'

describe 'Merchants search API' do
  describe 'single-find endpoint' do
    describe 'should send one merchant that matches search criteria' do
      it 'matches are case insensitive' do
        merchant1 = create(:merchant, name: 'The Brand Label')

        get '/api/v1/merchants/find?name=brand'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:name)
        expect(parsed[:data][:attributes][:name]).to be_a(String)
        expect(parsed[:data][:attributes][:name]).to eq(merchant1.name)
      end

      it 'can find partial matches' do
        merchant = create(:merchant, name: 'Brandiose') 

        get '/api/v1/merchants/find?name=io'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:name)
        expect(parsed[:data][:attributes][:name]).to be_a(String)
        expect(parsed[:data][:attributes][:name]).to eq(merchant.name)
      end
      
      it 'can get match based on timestamps' do
        merchant1 = create(:merchant, created_at: '2020-11-01')

        get '/api/v1/merchants/find?created_at=November+1'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)
        
        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:name)
        expect(parsed[:data][:attributes][:name]).to be_a(String)
        expect(parsed[:data][:attributes][:name]).to eq(merchant1.name)

        merchant2 = create(:merchant, updated_at: '2021-03-02')

        get '/api/v1/merchants/find?updated_at=02/03/2021'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:name)
        expect(parsed[:data][:attributes][:name]).to be_a(String)
        expect(parsed[:data][:attributes][:name]).to eq(merchant2.name)
      end
    end
  end

  describe 'multi-find endpoint' do
    describe 'should send all merchants that match search criteria' do
      it 'matches are case insensitive' do
        merchant1 = create(:merchant, name: 'brandless')
        merchant2 = create(:merchant, name: 'Brand The Label')

        get '/api/v1/merchants/find_all?name=brand'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_an(Array)

        parsed[:data].each do |merchant|
          expect(merchant).to have_key(:attributes)
          expect(merchant[:attributes]).to be_a(Hash)

          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_a(String)
        end

        expect(parsed[:data][0][:attributes][:name]).to eq(merchant1.name)
        expect(parsed[:data][1][:attributes][:name]).to eq(merchant2.name)
      end

      it 'can find partial matches' do
        merchant1 = create(:merchant, name: 'Brand The Label')
        merchant2 = create(:merchant, name: 'Lab Store')

        get '/api/v1/merchants/find_all?name=lab'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_an(Array)

        parsed[:data].each do |merchant|
          expect(merchant).to have_key(:attributes)
          expect(merchant[:attributes]).to be_a(Hash)

          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_a(String)
        end

        expect(parsed[:data][0][:attributes][:name]).to eq(merchant1.name)
        expect(parsed[:data][1][:attributes][:name]).to eq(merchant2.name)
      end
      
      it 'can get match based on timestamps' do
        merchant1 = create(:merchant, created_at: '2020-11-01')
        merchant2 = create(:merchant, created_at: '2020-11-01')

        get '/api/v1/merchants/find_all?created_at=November+1'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)
        
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_an(Array)

        parsed[:data].each do |merchant|
          expect(merchant).to have_key(:attributes)
          expect(merchant[:attributes]).to be_a(Hash)

          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_a(String)
        end

        expect(parsed[:data][0][:attributes][:name]).to eq(merchant1.name)
        expect(parsed[:data][1][:attributes][:name]).to eq(merchant2.name)

        merchant3 = create(:merchant, updated_at: '2021-03-02')
        merchant4 = create(:merchant, updated_at: '2021-03-02')

        get '/api/v1/merchants/find_all?updated_at=02/03/2021'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed[:data][0][:attributes][:name]).to eq(merchant3.name)
        expect(parsed[:data][1][:attributes][:name]).to eq(merchant4.name)
      end
    end
  end
end
