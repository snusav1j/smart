class AddColumnToP2psComissionRub < ActiveRecord::Migration[8.0]
  def change
    add_column :p2ps, :comission_rub, :float
  end
end
