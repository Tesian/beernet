class User < ActiveRecord::Base
  
  # Attributes
  attr_accessible :email, :username_google_calendar, 
                  :github_oauth_token, :gcal_oauth_token,
                  :dropbox_oauth_token, :password,
                  :password_confirmation, :remember_me
                  
  # Associations
  has_and_belongs_to_many :projects
  
  # Devise
  if Rails.env.production?
    devise :database_authenticatable, :recoverable, 
           :rememberable, :trackable, :validatable
  else
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable
  end
end
