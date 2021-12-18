class ProductsController < ApplicationController
  authorize_resource

  def home
    @products = Product.page(params[:page]).per(Settings.page_record_medium)
                       .recent
  end

  def show
    @product = Product.find_by id: params[:id]
    return if @product.present?

    flash[:warning] = t "not_found"
    redirect_to home_path
  end
end
