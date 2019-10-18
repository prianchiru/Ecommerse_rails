class ChangeUpdatedAtToBooks < ActiveRecord::Migration[6.0]
  def change
    change_column :books, :updated_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
