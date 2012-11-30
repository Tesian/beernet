class Event
  extend  ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion

  def as_json(options = {})
    {
      :id               => self.id,
      :title            => self.title,
      :description      => self.description || "",
      :start            => self.start_time,
      :end              => self.end_time,
      :allDay           => self.all_day,
      :recurring        => false,
      :url              => "events/" + self.id.to_s
    }
  end

  def get_google_event(event_google)
    self.id          = event_google.id
    self.title       = event_google.title
    self.description = event_google.content
    self.start_time  = event_google.start_time
    self.end_time    = event_google.end_time
    self.all_day     = event_google.all_day
  end

  def persisted?
    false
  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

  attr_accessor :id, :title, :description, :start_time, :end_time, :all_day, :where
end
