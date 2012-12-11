class TypeAccess < ActiveRecord::Base

  has_many            :accesses, through: :access_type_accesses
  has_many            :access_type_accesses

  attr_accessible       :name
end
