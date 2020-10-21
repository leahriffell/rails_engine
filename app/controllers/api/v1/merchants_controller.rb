class Api::V1::MerchantsController < ApplicationController
  def items
    render json: ItemSerializer.new(Merchant.find(merchant_params[:id]).items)
  end

  def merchant_params
    params.permit(:id)
  end
end