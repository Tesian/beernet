class Access < ActiveRecord::Base

  has_and_belongs_to_many       :type_accesses
  belongs_to                    :project

  attr_accessible               :address, :login, :password

  accepts_nested_attributes_for :type_accesses,
                                :allow_destroy => true
  attr_accessible               :type_accesses_attributes


  def repo_name
    return self.address.split('/').last.split('.').first
  end

  def type_accesses_attributes=(hash)
    hash.each do |sequence,type_access_values|
      type_accesses <<  TypeAccess.find_or_create_by_name(type_access_values[:name])
    end
  end

end
