require 'lhm'
class AddJournalToBooks < ActiveRecord::Migration[6.0]
  def change
    Lhm.cleanup(:run)
    Lhm.change_table :books do |t|
      t.add_column :journal, "VARCHAR(30)"
    end
  end
end
