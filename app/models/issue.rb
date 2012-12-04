class Issue
  extend  ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion

  attr_accessor :title, :body, :labels, :milestone
end
