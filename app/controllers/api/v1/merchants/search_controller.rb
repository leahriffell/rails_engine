class Api::V1::Merchants::SearchController < ApplicationController
  def single_result
    render json: MerchantSerializer.new(Merchant.single_search(search_attribute, search_value))
  end

  def multi_result
    render json: MerchantSerializer.new(Merchant.multi_search(search_attribute, search_value)).serialized_json
  end
  private

  def search_params
    params.permit(:name, :created_at, :updated_at)
  end
  
  def search_attribute
    search_params.keys[0]
  end

  def search_value
    search_params[search_attribute]
  end
end