class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items

  validates :name, presence: true

  def total_revenue
    sql = "SELECT SUM(unit_price * invoice_items.quantity) AS total FROM invoices
    INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id 
    INNER JOIN transactions ON invoices.id = transactions.invoice_id
    INNER JOIN items ON invoice_items.item_id = items.id
    WHERE transactions.result = 0 AND invoices.merchant_id = #{self.id};"

    result = ActiveRecord::Base.connection.exec_query(sql).rows.first.first
  end
end