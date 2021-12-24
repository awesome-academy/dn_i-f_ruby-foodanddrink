class Admin::ProductsController < Admin::AdminsController
  before_action :load_product, only: %i(show edit update remove_image destroy)
  before_action :load_order_details, only: :destroy

  def index
    @title = t "admin_product.title"
    @q = Product.ransack(params[:q], auth_object: set_ransack_auth_object)
    show_products
    return unless @products.empty?

    flash.now[:warning] = t "admin_product.not_find"
    @products = Product.recent.page(params[:page])
                       .per(Settings.page_record_medium_10)
  end

  def show
    @title = t "show_product_admin.title"
  end

  def edit
    @title = t "edit_product.title"
  end

  def update
    if @product.update(product_params)
      flash[:success] = t "edit_product.success"
      redirect_to admin_product_path(@product)
    else
      flash[:danger] = t "edit_product.fail"
      render :edit
    end
  end

  def remove_image
    @product.image.purge
    redirect_back(fallback_location: admin_orders_path(@product))
  end

  def new
    @title = t "new_product_admin.title"
    @product = Product.new
    @product.build_category
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "new_product_admin.success"
      redirect_to admin_product_path(@product)
    else
      flash[:danger] = t "new_product_admin.fail"
      render :new
    end
  end

  def destroy
    if @order_detail.present?
      flash[:danger] = t "delete_product.fail"
    else
      @product.destroy
      flash[:success] = t "delete_product.success"
    end
    redirect_to admin_products_path
  end

  private

  def set_ransack_auth_object
    current_user&.admin? ? :admin : nil
  end

  def show_products
    @products = @q.result.includes(:category).recent.page(params[:page])
                  .per(Settings.page_record_medium_10)
  end

  def product_params
    params.require(:product)
          .permit(:name, :price, :description, :quantity,
                  :category_id, :image,
                  category_attributes: :name)
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "not_found"
    redirect_to admin_products_path
  end

  def load_order_details
    @order_detail = OrderDetail.find_by(product_id: @product.id)
  end
end
