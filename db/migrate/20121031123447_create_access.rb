class CreateAccess < ActiveRecord::Migration
  def up
    create_table :access do |t|
      t.string :login
      t.string :password
      t.string :address
    end
  end
  def down
    drop_table :access
  end
end
