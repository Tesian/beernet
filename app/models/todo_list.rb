class TodoList < ActiveRecord::Base
  
  has_many              :todos
  belongs_to            :project

  attr_accessible       :name

  accepts_nested_attributes_for :todos,
                                :allow_destroy => true
  attr_accessible               :todos_attributes

end
