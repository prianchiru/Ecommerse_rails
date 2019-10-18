class CreateTableLaptops < ActiveRecord::Migration[6.0]
  def change
    create_table :laptops do |t|
      t.column :name, :string
    end
  end
end
