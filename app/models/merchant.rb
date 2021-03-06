class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items
  has_many :transactions
  
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
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select("merchants.*, merchants.name, SUM(invoice_items.unit_price * invoice_items.quantity) AS total")
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .group("merchants.id")
    .order("total DESC")
    .limit(num_limit)
  end

  def self.rank_by_num_items_sold(num_limit)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select("merchants.id, merchants.name, sum(invoice_items.quantity) AS num_items")
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .group("merchants.id")
    .order("num_items DESC")
    .limit(num_limit)
  end

  def self.revenue_between_dates(start_date, end_date)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .where(invoices: {created_at: start_date.to_datetime.beginning_of_day..end_date.to_datetime.end_of_day})
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_revenue
    invoices.joins(:invoice_items, :transactions)
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped', merchant_id: self.id})
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end
end