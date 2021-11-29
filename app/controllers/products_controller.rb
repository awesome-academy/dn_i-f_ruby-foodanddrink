class ProductsController < ApplicationController
  def home
    @products = Product.all.page(params[:page]).per(Settings.page_record_medium)
                       .recent
  end
end
