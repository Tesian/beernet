class Issue
  extend  ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion

  def get_issue(issue)
    self.body      = issue[:body]
    self.number    = issue[:number]
    self.title     = issue[:title]
    self.labels = []

    issue.labels.each do | label |
      self.labels.push(label.name)
    end

    if issue[:milestone] != nil
      self.milestone = issue[:milestone][:number]
    end
    
    if issue[:assignee] != nil
      self.assignee  = issue[:assignee][:login]
    end
  end

  def persisted?
    false
  end

  attr_accessor :title, :body, :labels, :milestone, :number, :assignee
end
