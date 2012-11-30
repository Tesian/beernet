class Contact < ActiveRecord::Base

  belongs_to            :contact

  attr_accessible       :email, :firstname, :lastname, :other_data, :phone
end
