require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it {should have_many :invoices}
  end
end
