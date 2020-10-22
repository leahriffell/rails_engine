class Api::V1::Merchants::BizIntelController < ApplicationController
  def merchant_revenue
    render json: RevenueSerializer.new(Merchant.find(params[:id]))
  end

  def rank_by_revenue
    merchants = Merchant.rank_by_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants).serialized_json
  end

  def rank_by_items_sold
    merchants = Merchant.rank_by_num_items_sold(params[:quantity])
    render json: MerchantSerializer.new(merchants).serialized_json
  end
end