class Access < ActiveRecord::Base
  extend Enumerize

  enumerize :genre, in: [:git, :ssh, :ftp, :ovh, :heroku], default: :git

  belongs_to                    :project

  attr_accessible               :address, :login, :password, :genre

  def repo_name
    return self.address.split('/').last.split('.').first
  end

end
