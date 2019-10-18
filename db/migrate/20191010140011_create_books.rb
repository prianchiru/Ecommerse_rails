class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.column :name, :string
      t.column :price, :float
      t.column :count, :integer
      t.column :author, :string
      t.column :published, :integer
      t.timestamps
    end
  end
end
