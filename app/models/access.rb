class Access < ActiveRecord::Base

  has_one :type_accesses

  attr_accessible :address, :login, :password
end
