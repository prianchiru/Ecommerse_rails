class ChangeDefalutToBooks < ActiveRecord::Migration[6.0]
  def change
    change_column :books, :created_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
