class Issue
  extend  ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion


  def get_issue(issue)
    self.body      = issue.body
    self.labels    = issue.labels
    self.milestone = issue.milestone
    self.number    = issue.number
    self.title     = issue.title
  end

  attr_accessor :title, :body, :labels, :milestone, :number
end
