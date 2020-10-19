require 'rails_helper'

describe 'Items API' do
  describe 'items index' do
    it 'sends a list of items' do
      merchant_with_items(item_count: 5)
      merchant_with_items(item_count: 5)

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
    end

    it 'sends an empty array if no items' do
      get '/api/v1/items'
  
      expect(response).to be_successful
  
      items = JSON.parse(response.body)

      expect(items).to eq([])
    end
  end

  describe 'item show' do
    before :each do 
      merchant = create(:merchant)
      @id = create(:item, merchant_id: merchant.id).id
    end

    it 'sends specific item' do
      get "/api/v1/items/#{@id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

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

    xit 'sends 404 response when no item is found' do
      get "/api/v1/items/1"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'item create new' do
    before :each do
      @merchant = create(:merchant)
    end

    it 'can create a new item when all required fields are provided' do
      item_params = ({
        name: 'Raw Chocolate Vegan Protein Powder',
        description: 'Made from organic Canadian peas and organic sprouted brown rice with 100% mechanical processing of proteins. All 9 essential amino acids and ONLY 4 ingredients.',
        unit_price: 59.99,
        merchant_id: @merchant.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
      expect(created_item.merchant_id).to eq(@merchant.id)
    end

    xit "cannot create a new item when all required fields aren't provided" do
    end

    xit "cannot create a new item when merchant provided does not exist" do
    end
  end

  describe 'item update to existing' do
    before :each do
      merchant = create(:merchant)
      @item = create(:item, merchant_id: merchant.id)
    end

    it 'can update existing item' do
      previous_name = Item.last.name
      item_params = { name: "Handy Dandy Notebook" }
      headers = {"CONTENT_TYPE" => "application/json"}
    
      patch "/api/v1/items/#{@item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: @item.id)
    
      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Handy Dandy Notebook")
    end

    xit 'cannot update existing item with incorrect datatype provided' do
    end

    xit 'can do ___ when item to update is not found' do
    end
  end

  describe 'item destroy' do
    it 'can destroy an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    xit 'can do _____ when item to destroy is not found' do
    end
  end
end
