class Client < ActiveRecord::Base

  has_many      :contacts

  accepts_nested_attributes_for :contacts,
                                allow_destroy: true
  attr_accessible :contacts_attributes


  attr_accessible :name, :street, :town, :zip

end
