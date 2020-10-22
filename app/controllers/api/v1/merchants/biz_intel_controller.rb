class Api::V1::Merchants::BizIntelController < ApplicationController
  def merchant_revenue
    render json: RevenueSerializer.new(Merchant.find(params[:id]).total_revenue)
  end

  def rank_by_revenue
    merchants = Merchant.rank_by_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants).serialized_json
  end

  def rank_by_items_sold
    merchants = Merchant.rank_by_num_items_sold(params[:quantity])
    render json: MerchantSerializer.new(merchants).serialized_json
  end

  def revenue_between_dates
    revenue = Merchant.revenue_between_dates(params[:start], params[:end])
    render json: RevenueSerializer.new(revenue)
  end
end