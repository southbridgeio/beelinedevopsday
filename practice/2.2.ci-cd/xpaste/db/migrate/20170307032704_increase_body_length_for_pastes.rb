class IncreaseBodyLengthForPastes < ActiveRecord::Migration[4.2]
  def change
    change_column :pastes, :body, :text, limit: 512 * 1024
  end
end
