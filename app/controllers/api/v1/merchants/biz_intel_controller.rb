class Api::V1::Merchants::BizIntelController < ApplicationController
  def merchant_revenue
    render json: RevenueSerializer.new(Merchant.find(params[:id]))
  end
end