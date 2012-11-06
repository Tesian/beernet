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
    if ((cal = GCal4Ruby::Calendar.find(service, {:title => @project.name})) == nil)
      cal = GCal4Ruby::Calendar.new(service, {:title => @project.name})
    end
  end

end
