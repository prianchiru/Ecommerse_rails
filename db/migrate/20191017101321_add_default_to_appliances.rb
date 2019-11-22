class AddDefaultToAppliances < ActiveRecord::Migration[6.0]
  def change
    change_column :appliances, :updated_at, :datetime
    change_column :appliances, :created_at, :datetime

    change_column :users, :updated_at, :datetime
    change_column :users, :created_at, :datetime
  end
end
