class AddDefaultValueToCreatedAtColumnBooks < ActiveRecord::Migration[6.0]
  def change
    change_column :books, :created_at, :datetime, :default => 0
  end
end
