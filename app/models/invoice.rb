class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: { 'shipped': 0 }

  validates :status, presence: true

  def paid?
    transactions.exists?(result: 0)  
  end
end