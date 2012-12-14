class CreateTodoList < ActiveRecord::Migration
  def up
    create_table :todo_lists do |t|
      t.string   :name
      t.integer  :project_id
    end
    add_index    :todo_lists, :project_id
  end

  def down
    remove_index :todo_lists, :project_id
    drop_table   :todo_lists
  end
end
