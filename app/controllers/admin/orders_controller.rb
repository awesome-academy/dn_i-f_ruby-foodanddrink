class Admin::OrdersController < Admin::AdminsController
  before_action :load_order, only: :show

  def index
    @title = t "orders.all"
    @orders = Order.includes(:order_details, :user)
                   .recent_orders.page(params[:page])
                   .per(Settings.page_record_medium_10)
  end

  def show
    @title = t "orders.order_detail"
    @order_detail = @order.order_details.includes(:product)
    @total = total_order @order_detail
  end

  private

  def load_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "orders.no_order"
    redirect_to admin_orders_path
  end

  def total_order order_detail
    order_detail.reduce(0) do |total, order|
      total + order.quantity * order.product_price
    end
  end
end
