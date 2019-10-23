require 'lhm'

class AddIndex < ActiveRecord::Migration[6.0]
  def change
    Lhm.cleanup(:run)
    Lhm.change_table :books do |t|
      t.add_column :journal, "VARCHAR(30)"
      t.add_unique_index [:name, :journal]
    end

    Lhm.change_table :appliances do |t|
      t.add_column :warrenty_in_years, "FLOAT"
      t.add_unique_index [:name, :warrenty_in_years]
    end
  end
end
