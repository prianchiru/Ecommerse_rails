class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.column :name, :string
      t.column :username, :string
      t.column :password_digest, :string
      t.timestamps
    end
  end
end
