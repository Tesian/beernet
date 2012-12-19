class CreateDropbox < ActiveRecord::Migration
  def up
    create_table :boxes do |t|
      t.integer  :project_id
      t.string   :username
      t.string   :auth_token
    end
    add_index :boxes, :project_id
  end

  def down
    remove_index :boxes, :project_id
    drop_table   :boxes
  end
end
