class ChangeUpdatedAtToBooks < ActiveRecord::Migration[6.0]
  def change
    change_column :books, :updated_at, :datetime
  end
end
