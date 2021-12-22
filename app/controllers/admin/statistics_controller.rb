class Admin::StatisticsController < Admin::AdminsController
  skip_authorize_resource

  def index; end

  def order_status
    render json: Order.group(:status).count
  end

  def order_total_money
    render json: Order.confirmed.send("group_by_#{params[:type]}", :created_at)
                      .sum(:total_price)
  end

  def count_order
    render json: Order.confirmed.send("group_by_#{params[:type]}", :created_at)
                      .count
  end
end
