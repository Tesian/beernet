class AccessTypeAccess < ActiveRecord::Base
  belongs_to :access
  belongs_to :type_access
end
