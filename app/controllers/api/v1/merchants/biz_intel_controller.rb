class Api::V1::Merchants::BizIntelController < ApplicationController
  def merchant_revenue
    render json: RevenueSerializer.new(Merchant.find(params[:id]))
  end

  def rank_by_revenue
    merchants = Merchant.rank_by_revenue(params[:quantity]).map do |merchant|
      Merchant.find(merchant[0])
    end

    render json: MerchantSerializer.new(merchants).serialized_json
  end
end