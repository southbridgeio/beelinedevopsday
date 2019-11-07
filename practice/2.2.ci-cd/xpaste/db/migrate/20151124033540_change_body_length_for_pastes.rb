class ChangeBodyLengthForPastes < ActiveRecord::Migration[4.2]
  def change
    change_column :pastes, :body, :text, limit: 128 * 1024
  end
end
