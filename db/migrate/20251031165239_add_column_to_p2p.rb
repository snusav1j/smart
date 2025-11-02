class AddColumnToP2p < ActiveRecord::Migration[8.0]
  def change
    add_column :p2ps, :usdt_count, :float
  end
end
