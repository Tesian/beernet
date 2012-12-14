class Project < ActiveRecord::Base

  has_and_belongs_to_many       :users
  has_many                      :accesses
  has_many                      :todo_lists

  attr_accessible               :name, :description

end
