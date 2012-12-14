class ProjectsController < ApplicationController
  include Coast

  def calendar
    @project = Project.find(params[:id])
    render "calendar"
  end

  # before :index do
  #   service = GCal4Ruby::Service.new
  #   service.authenticate(current_user.username_google_calendar, current_user.password_google_calendar)
  #   @calendars = service.calendars
  #   @calendar_title = []
  #   @calendars.each do |calendar|
  #     @calendar_title.push(calendar.title)
  #   end
  # end

  respond_to :destroy do
    respond_to do |format|
      format.html { redirect_to projects_url }
      format_json_and_xml(format, @resourceful_item)
    end
  end

end
