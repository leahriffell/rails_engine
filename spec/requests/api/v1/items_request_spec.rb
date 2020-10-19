require 'rails_helper'

describe 'Items API' do
  describe 'items index' do
    it 'sends a list of items' do
      FactoryBot.merchant_with_items(item_count: 5)
      FactoryBot.merchant_with_items(item_count: 5)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items.count).to eq(10)
      
      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(Integer)

        expect(item).to have_key(:name)
        expect(item[:name]).to be_a(String)

        expect(item).to have_key(:description)
        expect(item[:name]).to be_a(String)

        expect(item).to have_key(:unit_price)
        expect(item[:unit_price]).to be_a(Float)

        expect(item).to have_key(:merchant_id)
        expect(item[:merchant_id]).to be_an(Integer)
      end

      it 'sends an empty array if no items' do
        get '/api/v1/items'
    
        expect(response).to be_successful
    
        items = JSON.parse(response.body)

        expect(items).to eq([])
      end
    end
  end

  describe 'item show' do
    before :each do 
      @id = FactoryBot.create(:item).id
    end

    it 'sends specific item' do
      get "/api/v1/items/#{@id}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items.count).to eq(1)

      expect(item).to have_key(:id)
      expect(item[:id]).to eq(@id)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_an(Integer)
    end

    it 'sends _____ when no item is found' do
      get "/api/v1/items/#{@id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to eq("what should this equal?")
    end
  end

  describe 'item create new' do
    before :each do
      @merchant = FactoryBot.create(:merchant)
    end

    it 'can create a new item when all required fields are provided' do
      item_params = ({
        name: 'Raw Chocolate Vegan Protein Powder',
        description: 'Made from organic Canadian peas and organic sprouted brown rice with 100% mechanical processing of proteins. All 9 essential amino acids and ONLY 4 ingredients.',
        unit_price: 59.99,
        merchant_id: @merchant_id.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
      expect(created_item.merchant).to eq(@merchant)
    end

    it "cannot create a new item when all required fields aren't provided" do
    end

    it "cannot create a new item when merchant provided does not exist" do
    end
  end

  describe 'item update to existing' do
    it 'can update existing item' do
    end

    it 'cannot update existing item with incorrect datatype provided' do
    end

    it 'can do ___ when item to update is not found' do
    end
  end

  describe 'item destroy' do
    it 'can destroy an item' do
    end

    it 'can do _____ when item to destroy is not found' do
    end
  end
end
