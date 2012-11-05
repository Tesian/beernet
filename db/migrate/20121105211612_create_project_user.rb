class CreateProjectUser < ActiveRecord::Migration
  def up
    create_table :projects_users do | t |
      t.integer :user_id
      t.integer :project_id
    end
    add_index :projects_users, :user_id
    add_index :projects_users, :project_id
  end

  def down
    remove_index :projects_users, :user_id
    remove_index :projects_users, :project_id
    drop_table   :projects_users
  end
end
