class AddWillBeDeletedAtToPastes < ActiveRecord::Migration[4.2]
  def up
    add_column :pastes, :will_be_deleted_at, :datetime
  end

  def down
    remove_column :pastes, :will_be_deleted_at
  end
end
