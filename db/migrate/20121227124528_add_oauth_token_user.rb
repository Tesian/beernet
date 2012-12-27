class AddOauthTokenUser < ActiveRecord::Migration
  def up
    remove_column :users, :username_google_calendar
    remove_column :users, :password_google_calendar
    remove_column :users, :username_github
    remove_column :users, :password_github
    add_column    :users, :github_oauth_token, :string, :default => ""
    add_column    :users, :dropbox_oauth_token, :string, :default => ""
    add_column    :users, :dropbox_secret, :string, :default => ""
    add_column    :users, :gcal_oauth_token, :string, :default => ""
  end

  def down
    remove_column :users, :github_oauth_token
    remove_column :users, :dropbox_oauth_token
    remove_column :users, :dropbox_secret
    remove_column :users, :gcal_oauth_token
    add_column    :users, :username_google_calendar, :string
    add_column    :users, :password_google_calendar, :string
    add_column    :users, :username_github, :string
    add_column    :users, :password_github, :string
  end
end
