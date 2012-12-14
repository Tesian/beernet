class TodoList < ActiveRecord::Base
  
  has_many              :todos
  belongs_to            :project

  attr_accessible       :name
end
