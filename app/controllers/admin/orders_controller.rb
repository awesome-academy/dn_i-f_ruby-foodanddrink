class Admin::OrdersController < Admin::AdminsController
  def index
    @title = t "orders.all"
    @orders = Order.includes(:order_details, :user)
                   .recent_orders.page(params[:page])
                   .per(Settings.page_record_medium_10)
  end
end
