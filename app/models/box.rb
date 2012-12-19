class Box < ActiveRecord::Base
  belongs_to :projects


  attr_accessible :username, :auth_token
end
