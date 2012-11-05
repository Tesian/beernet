module AccessesHelper

  def setup_access(access)
    if access.type_access == nil
      access.type_access = TypeAccess.new
    end
    access
  end

end
