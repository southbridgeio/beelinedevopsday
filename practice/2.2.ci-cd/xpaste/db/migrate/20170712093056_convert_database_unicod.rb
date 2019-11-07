class ConvertDatabaseUnicod < ActiveRecord::Migration[4.2]
  def change
    if ActiveRecord::Base.connection.adapter_name == 'MySQL'
      execute "
        ALTER TABLE pastes
          CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
        MODIFY body TEXT(524288)
          CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
        "
    end
  end
end
