class AddIndexForPermalinks < ActiveRecord::Migration[4.2]
  def up
    add_index :pastes, :permalink, unique: true, length: 32
  end

  def down
    remove_index :pastes, :permalink
  end
end
