class CartsController < ApplicationController
  before_action :require_login
  def index
    @list_product_id = session[:cart].keys
    @products = Product.where(id: @list_product_id)
  end

  def create
    product = Product.find(params[:carts][:product_id])
    @quantity = params[:carts][:quantity].to_i
    set_quantity if product.present?
    respond_to do |format|
      format.js {}
    end
  end

  def set_quantity
    if session[:cart][params[:carts][:product_id]].nil?
      session[:cart][params[:carts][:product_id]] = if @quantity > 1
                                                      @quantity
                                                    else
                                                      1
                                                    end
    else
      session[:cart][params[:carts][:product_id]] += @quantity
    end
  end

  def tru
    product = Product.find(params[:id])
    if product.present?
      session[:cart][params[:id]] -= 1 if session[:cart][params[:id]] > 1
    end
    redirect_to carts_path
  end

  def destroy
    session[:cart].delete(params[:id])
    redirect_to carts_path
  end

  def add
    session[:cart][params[:id].to_s] += 1
    redirect_to carts_path
  end
end
