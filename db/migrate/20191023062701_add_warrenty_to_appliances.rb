require 'lhm'

class AddWarrentyToAppliances < ActiveRecord::Migration[6.0]
  def change
    Lhm.cleanup(:run)

    Lhm.change_table :appliances do |t|
      t.add_column :warrenty_in_years, "FLOAT"
    end
  end
end
