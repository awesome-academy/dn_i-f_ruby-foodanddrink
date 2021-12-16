class CartsController < ApplicationController
  before_action :user_signed_in?
  before_action :add, only: %i(create)
  def index
    @list_product_id = session[:cart].keys

    @products = Product.list_product(@list_product_id)
  end

  def create
    product = Product.find_by(id: params[:carts][:product_id])
    @quantity = params[:carts][:quantity].to_i
    set_quantity if product.present?
  end

  def update
    product = Product.find_by(id: params[:id])
    session[:cart][params[:id]] -= 1 if product.present? &&
                                        session[:cart][params[:id]] > 1
    redirect_to carts_path
  end

  def destroy
    session[:cart].delete(params[:id])
    redirect_to carts_path
  end

  private
  def set_quantity
    if session[:cart][params[:carts][:product_id]].nil?
      session[:cart][params[:carts][:product_id]] =
        @quantity > 1 ? @quantity : 1
    else
      session[:cart][params[:carts][:product_id]] += @quantity
    end
  end

  def add
    quantity = params[:carts][:quantity]
    return if quantity

    session[:cart][params[:carts][:product_id]] += 1
    redirect_to carts_path
  end
end
