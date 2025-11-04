class AddUserIdToP2pFiles < ActiveRecord::Migration[8.0]
  def change
    add_column :p2p_files, :user_id, :integer
    add_column :p2p_files, :stored_path, :string

    add_index :p2p_files, :user_id
  end
end
