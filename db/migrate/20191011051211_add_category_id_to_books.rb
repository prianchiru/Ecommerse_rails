class AddCategoryIdToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :category_id, :integer
    add_column :appliances, :category_id, :integer
  end
end
