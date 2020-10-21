class Item < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  belongs_to :merchant
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  
  def self.single_search(attribute, value)
    if attribute == 'unit_price'
      Item.find_by("#{attribute} = #{value.to_f}")
    elsif attribute == 'created_at' || attribute == 'updated_at'
      Item.find_by("#{attribute} = '%#{value.to_date}%'")
    elsif value.class == Float || value.class == Integer
      Item.find_by("#{attribute} = #{value}")
    elsif Item.find_by("LOWER(#{attribute}) = LOWER('#{value}')") == nil
      Item.find_by("LOWER(#{attribute}) LIKE LOWER('%#{value}%')")
    else
      Item.find_by("LOWER(#{attribute}) = LOWER('#{value}')")
    end
  end

  def self.multi_search(attribute, value)
    if attribute == 'unit_price'
      Item.where("#{attribute} = #{value.to_f}")
    elsif attribute == 'created_at' || attribute == 'updated_at'
      Item.where("#{attribute} = '%#{value.to_date}%'")
    elsif value.class == Float || value.class == Integer
      Item.where("#{attribute} = #{value}")
    else
      Item.where("LOWER(#{attribute}) LIKE LOWER('%#{value}%')")
    end
  end
end