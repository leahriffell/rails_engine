require 'csv'

InvoiceItem.destroy_all
Item.destroy_all
Invoice.destroy_all
Transaction.destroy_all
Customer.destroy_all
Merchant.destroy_all

CSV.foreach('lib/data/customers.csv', headers: true, header_converters: :symbol) do |row|
  Customer.create(row.to_h)
end

CSV.foreach('lib/data/merchants.csv', headers: true, header_converters: :symbol) do |row|
  Merchant.create(row.to_h)
end

CSV.foreach('lib/data/invoices.csv', headers: true, header_converters: :symbol) do |row|
  Invoice.create(row.to_h)
end

CSV.foreach('lib/data/items.csv', headers: true, header_converters: :symbol) do |row|
  Item.create(row.to_h)
end

CSV.foreach('lib/data/invoice_items.csv', headers: true, header_converters: :symbol) do |row|
  InvoiceItem.create(row.to_h.except(:unit_price))
end

CSV.foreach('lib/data/transactions.csv', headers: true, header_converters: :symbol) do |row|
  Transaction.create(row.to_h)
end

