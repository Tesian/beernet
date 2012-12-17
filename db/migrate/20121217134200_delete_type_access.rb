class DeleteTypeAccess < ActiveRecord::Migration
  def up
    remove_index :accesses_type_accesses, :access_id
    remove_index :accesses_type_accesses, :type_access_id
    drop_table   :accesses_type_accesses
    drop_table   :type_accesses

    add_column   :accesses, :genre, :string
  end

  def down
    remove_column :accesses, :genre, :string

    create_table  :type_accesses do |t|
      t.string    :name
      t.integer   :access_id
    end

    create_table :accesses_type_accesses do |t|
      t.integer  :type_access_id
      t.integer  :access_id
    end

    add_index    :accesses_type_accesses, :access_id
    add_index    :accesses_type_accesses, :type_access_id

  end
end
