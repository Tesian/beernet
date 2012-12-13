class FixTypeAccess < ActiveRecord::Migration
  def up
    drop_table :access
    
    remove_index :type_accesses, :access_id
    remove_column :type_accesses, :access_id

    create_table :accesses_type_accesses do |t|
      t.integer :type_access_id
      t.integer :access_id
    end

    add_index :accesses_type_accesses, :access_id
    add_index :accesses_type_accesses, :type_access_id
  end

  def down
    create_table :access do |t|
      t.string :login
      t.string :password
      t.string :address
    end

    add_column :type_accesses, :access_id, :integer
    add_index :type_accesses, :access_id

    remove_index :accesses_type_accesses, :access_id
    remove_index :accesses_type_accesses, :type_access_id
    drop_table :accesses_type_accesses
  end
end
