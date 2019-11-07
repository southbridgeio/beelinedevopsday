class CreatePastes < ActiveRecord::Migration[4.2]
  def up
    create_table :pastes do |t|
      t.text :body
      t.text :request_info
      t.text :permalink
      t.string :language

      t.timestamps null: false
    end
  end

  def down
    drop_table :pastes
  end
end
