class AddDefaultValueToCreatedAtColumnBooks < ActiveRecord::Migration[6.0]
  def change
    change_column :books, :created_at, :datetime
  end
end
