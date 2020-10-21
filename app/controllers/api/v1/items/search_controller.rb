class Api::V1::Items::SearchController < ApplicationController
  def single_result
    render json: ItemSerializer.new(Item.single_search(search_attribute, search_value))
  end

  private

  def search_params
    params.permit(:name, :description, :created_at, :updated_at, :unit_price)
  end
  
  def search_attribute
    search_params.keys[0]
  end

  def search_value
    search_params[search_attribute]
  end
end