class AddAutoDestroyToPastes < ActiveRecord::Migration[4.2]
  def change
    add_column :pastes, :auto_destroy, :boolean, default: false, null: false
  end
end
