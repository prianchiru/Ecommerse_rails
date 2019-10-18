class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.column :name, :string
      t.timestamps
    end
  end
end
