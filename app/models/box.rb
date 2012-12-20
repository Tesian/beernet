class Box < ActiveRecord::Base
  belongs_to :projects


  attr_accessible :app_name, :app_secret, :auth_token
end
