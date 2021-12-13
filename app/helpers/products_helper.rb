module ProductsHelper
  def display_product_img product
    if product.image.attached?
      image_tag(product.display_image)
    else
      gravatar_for(product)
    end
  end
end
