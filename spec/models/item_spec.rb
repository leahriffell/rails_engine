require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it {should have_many :invoice_items}
    it {should belong_to :merchant}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
  end

  describe 'class methods' do
    describe 'single_search(attribute, value)' do
      it 'matches an exact match' do
        fuzzy_match = create(:item, name: 'Ring Security System')
        exact_match = create(:item, name: 'ring')

        expect(Item.single_search('name', 'ring')).to eq(exact_match)
      end

      it 'matches case insensitively' do
        item = create(:item, name: 'Ring Security System')

        expect(Item.single_search('name', 'ring')).to eq(item)
      end

      it 'can find partial match' do
        item = create(:item, name: 'Bring It On soundtrack')
        expect(Item.single_search('name', 'ring')).to eq(item)
      end

      it 'can match based on timestamps' do
        item = create(:item, created_at: '2020-10-31')
        expect(Item.single_search('created_at', 'October+31')).to eq(item)

        item = create(:item, updated_at: '2021-01-01')
        expect(Item.single_search('updated_at', '1/1/2021')).to eq(item)
      end

      it 'can get match based on description' do
        item = create(:item, description: 'Use the Multi-Color LED Flashlight to cast a sickly green glow over your face while telling a zombie story around a campfire. No campfire? Make a fake one with the orange light!')
        expect(Item.single_search('description', 'light')).to eq(item)
      end

      it 'can get match based on unit price' do
        item = create(:item, unit_price: 1.99)
        expect(Item.single_search('unit_price', 1.99)).to eq(item)
      end
    end
  end
end
