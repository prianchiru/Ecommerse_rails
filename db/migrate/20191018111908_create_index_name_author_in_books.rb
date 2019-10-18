require 'lhm'
class CreateIndexNameAuthorInBooks < ActiveRecord::Migration[6.0]
  def change
    Lhm.change_table :books do |t|
      t.add_index [:name, :author]
    end
  end
end
