class TypeAccess < ActiveRecord::Base

  belongs_to            :accesses

  attr_accessible       :name
end
