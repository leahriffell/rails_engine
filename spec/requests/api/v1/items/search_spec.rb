require 'rails_helper'

describe 'Items search API' do
  # before :each do 
  #   create(:item, name: 'Stackable ring')
  #   create(:item, name: 'Ring Security System')
  #   create(:item, name: 'Bring It On soundtrack')
  # end

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
end


# This endpoint should return a single record that matches a set of criteria. Criteria will be input through query parameters.

# The URI should follow this pattern: GET /api/v1/<resource>/find?<attribute>=<value>

# This endpoint should:

# work for any attribute of the corresponding resource including the updated_at and created_at timestamps.
# find partial matches for strings and be case insensitive, for example a request to GET /api/v1/merchants/find?name=ring would match a merchant with the name Turing and a merchant with the name Ring World. Note: It does NOT need to accept multiple attributes, for example GET /api/v1/items/find?name=pen&description=blue
# Example JSON response for GET /api/v1/merchants/find?name=ring

# {
#   "data": {
#     "id": 4,
#     "type": "merchant",
#     "attributes": {
#       "name": "Ring World"
#     }
#   }
# }