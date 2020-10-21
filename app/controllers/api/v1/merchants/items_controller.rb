class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Merchant.find(merchant_params[:id]).items)
  end

  def merchant_params
    params.permit(:id)
  end
end