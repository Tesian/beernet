class AddLoginInUser < ActiveRecord::Migration
  def up
    add_column :users, :username_google_calendar, :string
    add_column :users, :password_google_calendar, :string
    add_column :users, :username_github, :string
    add_column :users, :password_github, :string
  end

  def down
    remove_column :users, :username_google_calendar
    remove_column :users, :password_google_calendar
    remove_column :users, :username_github
    remove_column :users, :password_github
  end
end
