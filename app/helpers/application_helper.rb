module ApplicationHelper
  def full_title page_title = ""
    base_title = t "manager"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def show_message_for_field obj, attribute
    full_messages_for = obj.errors.full_messages_for(attribute)
    return if full_messages_for.empty?

    content_tag :ul, class: "erorr_message" do
      full_messages_for.map{|msg| concat(content_tag(:li, msg))}
    end
  end

  def link_to_add_fields name, category, association
    ## create a new object from the association (:product_variants)
    new_object = category.object.send(association).class.new

    ## just create or take the id from the new created object
    id = new_object.object_id

    ## create the fields form
    fields =
      category.fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", category: builder)
      end
    ## pass down the link to the fields form
    link_to(name, "#", class: "add_fields",
    data: {id: id, fields: fields.gsub("\n", "")})
  end
end
