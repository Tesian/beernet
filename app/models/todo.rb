class Todo < ActiveRecord::Base
  belongs_to :todo_lists

  attr_accessible :body
end
