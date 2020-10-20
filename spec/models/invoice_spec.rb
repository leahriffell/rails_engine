require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it {should belong_to :customer}
    it {should belong_to :merchant}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many(:items).through(:invoice_items)}
  end

  describe 'validations' do
    it {should validate_presence_of :status}
  end

  describe 'instance methods' do
    describe 'paid?' do
      it 'can determine if invoice has at least one successful transaction' do
        # invoice with 1 successful and 1 failed transaction
        invoice1 = create(:invoice)
        create(:transaction, invoice_id: invoice1.id, result: 0)
        create(:transaction, invoice_id: invoice1.id, result: 1)

        # invoice with 2 failed transactions
        invoice2 = create(:invoice)
        2.times { create(:transaction, invoice_id: invoice2.id, result: 1) }

        # invoice with 2 successful transactions
        invoice3 = create(:invoice)
        2.times { create(:transaction, invoice_id: invoice3.id, result: 0) }
        
        expect(invoice1.paid?).to eq(true)
        expect(invoice2.paid?).to eq(false)
        expect(invoice3.paid?).to eq(true)
      end
    end
  end
end