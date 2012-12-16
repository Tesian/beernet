class User < ActiveRecord::Base
  
  # Attributes
  attr_accessible :email, :username_google_calendar, 
                  :password_google_calendar,
                  :username_github, :password_github, :password,
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
