class User < ActiveRecord::Base
  
  # Attributes
  attr_accessible :email, :github, :google, :dropbox, :password,
                  :uid, :password_confirmation, :remember_me
                  
  # Associations
  has_and_belongs_to_many :projects
  
  # Devise
  if Rails.env.production?
    devise :database_authenticatable, :recoverable, :rememberable,
           :trackable, :validatable, :omniauthable,
           :omniauth_providers => [:github]
  else
    devise :database_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :validatable, :omniauthable,
           :omniauth_providers => [:github]
  end
end
