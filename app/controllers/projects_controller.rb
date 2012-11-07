class ProjectsController < ApplicationController
include Coast

  before_filter :authenticate_user!

  def google_calendar
    render
  end

  def google_calendar_events
    @project = Project.find(params[:id])
    service = GCal4Ruby::Service.new
    service.authenticate(current_user.username_google_calendar, current_user.password_google_calendar)
    if ((cal = GCal4Ruby::Calendar.find(service, {:title => @project.name})).length == 0)
      cal = GCal4Ruby::Calendar.new(service, {:title => @project.name})
      cal.save
    end
    if cal.length == 1
      @events = cal.first.events
    else
      @events = cal.events
    end
    render "google_calendar_events", :layout => false
  end

  before :index do
    service = GCal4Ruby::Service.new
    service.authenticate(current_user.username_google_calendar, current_user.password_google_calendar)
    @calendars = service.calendars
    @calendar_title = []
    @calendars.each do |calendar|
      @calendar_title.push(calendar.title)
    end
  end

  respond_to :destroy do
    respond_to do |format|
      format.html { redirect_to projects_url }
      format_json_and_xml(format, @resourceful_item)
    end
  end

  after :create do
    co_google_calendar()
  end

end
