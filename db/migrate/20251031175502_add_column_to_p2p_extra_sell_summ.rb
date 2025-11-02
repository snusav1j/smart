class AddColumnToP2pExtraSellSumm < ActiveRecord::Migration[8.0]
  def change
    add_column :p2ps, :extra_sell_summ, :float
  end
end