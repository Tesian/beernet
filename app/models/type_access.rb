class TypeAccess < ActiveRecord::Base

  has_and_belongs_to_many :accesses

  attr_accessible         :name
end
