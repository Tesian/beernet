class AddTypeAccess < ActiveRecord::Migration
  def up
    create_table :type_accesses do | t |
      t.string  :name
      t.integer :access_id
    end
    add_index :type_accesses, :access_id
  end

  def down
    remove_index :type_accesses, :access_id
    drop_table :type_accesses
  end
end
