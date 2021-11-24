class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.float :price, null: false
      t.text :description
      t.integer :quantity, null: false

      t.timestamps
    end
    add_index :products, :price
    add_index :products, :name
  end
end
