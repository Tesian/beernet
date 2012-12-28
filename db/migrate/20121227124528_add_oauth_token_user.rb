class AddOauthTokenUser < ActiveRecord::Migration
  def up
    remove_column :users, :username_google_calendar
    remove_column :users, :password_google_calendar
    remove_column :users, :username_github
    remove_column :users, :password_github
    add_column    :users, :github, :string, :default => ""
    add_column    :users, :dropbox, :string, :default => ""
    add_column    :users, :google, :string, :default => ""
    add_column    :users, :uid, :string, :default => ""
  end

  def down
    remove_column :users, :github
    remove_column :users, :dropbox
    remove_column :users, :google
    remove_column :users, :uid
    add_column    :users, :username_google_calendar, :string
    add_column    :users, :password_google_calendar, :string
    add_column    :users, :username_github, :string
    add_column    :users, :password_github, :string
  end
end
