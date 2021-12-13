class OrdersController < ApplicationController
  before_action :require_login

  def index
    @list_product_id = session[:cart].keys
    @products = Product.where(id: @list_product_id)
    @user = User.find_by(id: session[:user_id])
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order.present?
      @order
    else
      flash[:warning] = t "booking_fail"
      redirect_to home_path
    end
  end

  def create
    @list_product_id = session[:cart].keys
    @products = Product.where(id: @list_product_id)
    @order = Order.new(
      user_id: session[:user_id],
      address_id: params[:address],
      total_price: params[:orders][:total]
    )
    create_order
  end

  def create_order
    if @order.save
      @products.each do |product|
        OrderDetail.create(
          quantity: session[:cart][product.id.to_s],
          actual_price: product.price,
          order: @order,
          product: product
        )
      end
      flash[:success] = t "booking_success"
      destroy_cart
    else
      flash[:warning] = t "booking_fail"
      redirect_to home_path
    end
  end

  private
  def destroy_cart
    session[:cart] = {}
    redirect_to @order
  end
end
