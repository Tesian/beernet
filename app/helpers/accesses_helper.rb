module AccessesHelper

  def setup_access(access)
    if access.type_accesses == []
      access.type_accesses[0] = TypeAccess.new
    end
    access
  end

end
