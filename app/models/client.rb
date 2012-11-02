class Client < ActiveRecord::Base

  has_many      :contacts

  attr_accessible :name, :street, :town, :zip
end
