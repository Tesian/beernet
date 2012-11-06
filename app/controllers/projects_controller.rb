class ProjectsController < ApplicationController
include Coast

  before_filter :authenticate_user!

  respond_to :destroy do
    respond_to do |format|
      format.html { redirect_to projects_url }
      format_json_and_xml(format, @resourceful_item)
    end
  end

  after :create do
    service = GCal4Ruby::Service.new
    service.authenticate(current_user.username_google_calendar, current_user.password_google_calendar)
    if ((cal = GCal4Ruby::Calendar.find(service, {:title => @project.name})).length == 0)
      cal = GCal4Ruby::Calendar.new(service, {:title => @project.name})
    end
      e = GCal4Ruby::Event.new(service, {:calendar => cal, :title => @project.name, :start_time => Time.parse("12-06-2012 at 12:30 PM"), :end_time => Time.parse("12-06-2012 at 1:30 PM"), :where => "Nowhere"})
  end

end
