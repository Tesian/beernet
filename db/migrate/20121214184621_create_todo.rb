class CreateTodo < ActiveRecord::Migration
  def up
    create_table :todos do |t|
      t.text     :body
      t.integer  :todo_list_id
    end
    add_index    :todos, :todo_list_id
  end

  def down
    remove_index :todos, :todo_list_id
    drop_table   :todos
  end
end
