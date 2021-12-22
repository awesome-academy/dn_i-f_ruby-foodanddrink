class Admin::OrdersController < Admin::AdminsController
  before_action :load_order, :load_order_details,
                except: %i(index)

  def index
    @title = t "orders.all"
    @q = Order.ransack(params[:q])
    show_orders
    return unless @orders.empty?

    flash.now[:warning] = t "admin_product.not_find"
    @orders = Order.recent_orders.page(params[:page])
                   .per(Settings.page_record_medium_10)
  end

  def show
    @title = t "orders.order_detail"
  end

  def approve
    ActiveRecord::Base.transaction do
      if @order.open?
        update_quantity_when_approve
        @order.confirmed!
        send_mail
        flash[:success] = t "orders.approve_success"
      else
        flash[:danger] = t "orders.failed"
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "orders.failed"
  ensure
    redirect_back(fallback_location: admin_orders_path)
  end

  def reject
    ActiveRecord::Base.transaction do
      update_quantity_when_reject if @order.confirmed?
      @order.disclaim!
      send_mail
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "orders.failed"
  else
    flash[:success] = t "orders.reject_success"
  ensure
    redirect_back(fallback_location: admin_orders_path)
  end

  private

  def show_orders
    @orders = @q.result.includes(:order_details, :user).recent_orders
                .page(params[:page]).per(Settings.page_record_medium_10)
  end

  def load_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "orders.no_order"
    redirect_to admin_orders_path
  end

  def total_price_order order_detail
    order_detail.reduce(0) do |total, order|
      total + order.quantity * order.product_price
    end
  end

  def load_order_details
    @order_detail = @order.order_details.includes(:product)
    @total = total_price_order @order_detail
  end

  def update_quantity_when_approve
    @order_detail.each do |detail|
      product = detail.product
      product.quantity -= detail.quantity
      product.save!
    end
  end

  def update_quantity_when_reject
    @order_detail.each do |detail|
      product = detail.product
      product.quantity += detail.quantity
      product.save!
    end
  end

  def send_mail
    UserMailer.order_status(@order, @order_detail, @total).deliver_now
  end
end
