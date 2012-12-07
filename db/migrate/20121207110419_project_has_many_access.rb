class ProjectHasManyAccess < ActiveRecord::Migration
  def up
    add_column :accesses, :project_id, :integer
    add_index  :accesses, :project_id
  end

  def down
    remove_index  :accesses, :project_id
    remove_column :accesses, :project_id
  end
end
