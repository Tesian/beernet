class AddHasManyRelationBetweenClientAndContact < ActiveRecord::Migration
  def up
    add_column :contacts, :client_id, :integer
    add_index :contacts, :client_id
  end

  def down
    remove_index :contacts, :client_id
    remove_column :contacts, :client_id
  end
end
