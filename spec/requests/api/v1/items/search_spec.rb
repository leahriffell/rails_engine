require 'rails_helper'

describe 'Items search API' do
  describe 'single-find endpoint' do
    describe 'should send one item that matches search criteria' do
      it 'matches are case insensitive' do
        item = create(:item, name: 'Ring Security System')

        get '/api/v1/items/find?name=ring'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:name)
        expect(parsed[:data][:attributes][:name]).to be_a(String)
        expect(parsed[:data][:attributes][:name]).to eq(item.name)
      end

      it 'can find partial matches' do
        item = create(:item, name: 'Bring It On soundtrack')

        get '/api/v1/items/find?name=ring'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:name)
        expect(parsed[:data][:attributes][:name]).to be_a(String)
        expect(parsed[:data][:attributes][:name]).to eq(item.name)
      end
      
      it 'can get match based on timestamps' do
        item1 = create(:item, created_at: '2020-11-01')

        get '/api/v1/items/find?created_at=November+1'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)
        
        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:name)
        expect(parsed[:data][:attributes][:name]).to be_a(String)
        expect(parsed[:data][:attributes][:name]).to eq(item1.name)

        item2 = create(:item, updated_at: '2021-03-02')

        get '/api/v1/items/find?updated_at=02/03/2021'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:name)
        expect(parsed[:data][:attributes][:name]).to be_a(String)
        expect(parsed[:data][:attributes][:name]).to eq(item2.name)
      end

      it 'can get match based on description' do
        item = create(:item, description: 'Use the Multi-Color LED Flashlight to cast a sickly green glow over your face while telling a zombie story around a campfire. No campfire? Make a fake one with the orange light!')

        get '/api/v1/items/find?description=light'

        expect(response).to be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)
        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:description)
        expect(parsed[:data][:attributes][:description]).to be_a(String)
        expect(parsed[:data][:attributes][:description]).to eq(item.description)
      end

      it 'can get match based on unit price' do
        item = create(:item, unit_price: 1.99)

        get '/api/v1/items/find?unit_price=1.99'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to be_a(Hash)
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data]).to have_key(:attributes)
        expect(parsed[:data]).to be_a(Hash)

        expect(parsed[:data][:attributes]).to have_key(:unit_price)
        expect(parsed[:data][:attributes][:unit_price]).to be_a(Float)
        expect(parsed[:data][:attributes][:unit_price]).to eq(item.unit_price)
      end
    end
  end

  describe 'multi-find endpoint' do
    describe 'should send all items that match search criteria' do
      it 'matches are case insensitive' do
        item1 = create(:item, name: 'Ring Security System')
        item2 = create(:item, name: 'ring')

        get '/api/v1/items/find_all?name=ring'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_an(Array)

        parsed[:data].each do |item|
          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)
        end

        expect(parsed[:data][0][:attributes][:name]).to eq(item1.name)
        expect(parsed[:data][1][:attributes][:name]).to eq(item2.name)
      end

      it 'can find partial matches' do
        item1 = create(:item, name: 'Bring It On soundtrack')
        item2 = create(:item, name: 'stackable rings')

        get '/api/v1/items/find_all?name=ring'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_an(Array)

        parsed[:data].each do |item|
          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)
        end

        expect(parsed[:data][0][:attributes][:name]).to eq(item1.name)
        expect(parsed[:data][1][:attributes][:name]).to eq(item2.name)
      end
      
      it 'can get match based on timestamps' do
        item1 = create(:item, created_at: '2020-11-01')
        item2 = create(:item, created_at: '2020-11-01')

        get '/api/v1/items/find_all?created_at=November+1'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)
        
        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_an(Array)

        parsed[:data].each do |item|
          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)
        end

        expect(parsed[:data][0][:attributes][:name]).to eq(item1.name)
        expect(parsed[:data][1][:attributes][:name]).to eq(item2.name)

        item3 = create(:item, updated_at: '2021-03-02')
        item4 = create(:item, updated_at: '2021-03-02')

        get '/api/v1/items/find_all?updated_at=02/03/2021'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed[:data][0][:attributes][:name]).to eq(item3.name)
        expect(parsed[:data][1][:attributes][:name]).to eq(item4.name)
      end

      it 'can get match based on description' do
        item1 = create(:item, description: 'Use the Multi-Color LED Flashlight to cast a sickly green glow over your face while telling a zombie story around a campfire. No campfire? Make a fake one with the orange light!')
        item2 = create(:item, description: 'This pendant light is perfect for any living room, dining room, kitchen island and more. Include 5-Watt LED warm light bulbs.')

        get '/api/v1/items/find_all?description=light'

        expect(response).to be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_an(Array)

        parsed[:data].each do |item|
          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_a(String)
        end

        expect(parsed[:data][0][:attributes][:description]).to eq(item1.description)
        expect(parsed[:data][1][:attributes][:description]).to eq(item2.description)
      end

      it 'can get match based on unit price' do
        item1 = create(:item, unit_price: 1.99)
        item2 = create(:item, unit_price: 1.99)

        get '/api/v1/items/find_all?unit_price=1.99'

        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)

        expect(parsed).to have_key(:data)
        expect(parsed[:data]).to be_an(Array)

        parsed[:data].each do |item|
          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_a(Float)
        end

        expect(parsed[:data][0][:attributes][:unit_price]).to eq(item1.unit_price)
        expect(parsed[:data][1][:attributes][:unit_price]).to eq(item2.unit_price)
      end
    end
  end
end
