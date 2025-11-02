class CreateP2p < ActiveRecord::Migration[8.0]
  def change
    create_table :p2ps do |t|
      t.integer :order_id
      t.integer :sell_order_id
      t.integer :user_id
      t.float :rub_per_usd
      t.float :order_sum
      t.integer :p2p_type
      t.integer :bank_id
      t.float :bank_comission
      t.boolean :tax_paid, default: false
      t.float :tax_rate, default: 13
      t.datetime :order_date

      t.timestamps
    end

    create_table :p2p_files do |t|
      t.references :p2p, foreign_key: true, null: false
      t.string :file_name, null: false

      t.timestamps
    end
  end
end
