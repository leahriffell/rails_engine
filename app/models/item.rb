class Item < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  belongs_to :merchant
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  
  def self.single_search(attribute, value)
    if attribute == 'created_at' || attribute == 'updated_at'
      Item.find_by("#{attribute} = '%#{value.to_date}%'")
    elsif value.class == Float || value.class == Integer
      Item.find_by("#{attribute} = #{value}")
    elsif Item.find_by("LOWER(#{attribute}) = LOWER('#{value}')") == nil
      Item.find_by("LOWER(#{attribute}) LIKE LOWER('%#{value}%')")
    else
      Item.find_by("LOWER(#{attribute}) = LOWER('#{value}')")
    end
  end 
end