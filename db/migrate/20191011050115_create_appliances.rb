class CreateAppliances < ActiveRecord::Migration[6.0]
  def change
    create_table :appliances do |t|
      t.column :name, :string
      t.column :price, :float
      t.column :count, :integer
      t.column :model, :string
      t.column :brand, :string

      t.timestamps
    end
  end
end
