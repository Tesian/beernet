class Access < ActiveRecord::Base

  has_one                       :type_access, through: :access_type_accesses
  has_one                       :access_type_accesses
  belongs_to                    :project

  attr_accessible               :address, :login, :password

  accepts_nested_attributes_for :type_access,
                                :allow_destroy => true
  attr_accessible               :type_access_attributes


  def repo_name
    return self.address.split('/').last.split('.').first
  end

  def type_access_attributes=(hash)
    TypeAccess.find_or_create_by_name(hash[:name])
  end

end
