class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :street
      t.string :zip
      t.string :town

      t.timestamps
    end
  end
end
