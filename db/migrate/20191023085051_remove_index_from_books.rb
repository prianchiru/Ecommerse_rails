class RemoveIndexFromBooks < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :journal
    remove_column :appliances, :warrenty_in_years
  end
end
