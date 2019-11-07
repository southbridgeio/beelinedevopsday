class AddColumnWillDeletedAtForPaste < ActiveRecord::Migration[5.2]
  def up
    add_column :pastes, :deleted_at, :datetime
  end

  def down
    remove_column :pastes, :deleted_at
  end
end
