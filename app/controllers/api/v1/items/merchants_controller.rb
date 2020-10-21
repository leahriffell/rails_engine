class Api::V1::Items::MerchantsController < ApplicationController
  def show
    render json: MerchantSerializer.new(Item.find(item_params[:id]).merchant)
  end

  private

  def item_params
    params.permit(:id)
  end
end
