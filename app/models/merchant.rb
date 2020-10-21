class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items
  
  validates :name, presence: true

  def self.single_search(attribute, value)
    if attribute == 'created_at' || attribute == 'updated_at'
      Merchant.find_by("#{attribute} = '%#{value.to_date}%'")
    elsif value.class == Float || value.class == Integer
      Merchant.find_by("#{attribute} = #{value}")
    elsif Merchant.find_by("LOWER(#{attribute}) = LOWER('#{value}')") == nil
      Merchant.find_by("LOWER(#{attribute}) LIKE LOWER('%#{value}%')")
    else
      Merchant.find_by("LOWER(#{attribute}) = LOWER('#{value}')")
    end
  end

  def self.multi_search(attribute, value)
    if attribute == 'created_at' || attribute == 'updated_at'
      Merchant.where("#{attribute} = '%#{value.to_date}%'")
    elsif value.class == Float || value.class == Integer
      Merchant.where("#{attribute} = #{value}")
    else
      Merchant.where("LOWER(#{attribute}) LIKE LOWER('%#{value}%')")
    end
  end

  def self.rank_by_revenue(num_limit)
    sql = "SELECT invoices.merchant_id, SUM(unit_price * invoice_items.quantity) AS total FROM invoices
    INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id 
    INNER JOIN transactions ON invoices.id = transactions.invoice_id
    INNER JOIN items ON invoice_items.item_id = items.id
  	WHERE transactions.result = 0
    GROUP BY invoices.merchant_id
    ORDER BY total DESC
    LIMIT #{num_limit};"

    result = ActiveRecord::Base.connection.exec_query(sql).rows
  end

  def total_revenue
    sql = "SELECT SUM(unit_price * invoice_items.quantity) AS total FROM invoices
    INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id 
    INNER JOIN transactions ON invoices.id = transactions.invoice_id
    INNER JOIN items ON invoice_items.item_id = items.id
    WHERE transactions.result = 0 AND invoices.merchant_id = #{self.id};"
    result = ActiveRecord::Base.connection.exec_query(sql).rows.first.first
    # require 'pry'; binding.pry
  end
end