class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :login
      t.string :password
      t.string :address

      t.timestamps
    end
  end
end
