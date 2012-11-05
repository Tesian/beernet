class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many       :projects



  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username_google_calendar, :password_google_calendar, :username_github, :password_github, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
end
