class EventsController < ApplicationController

  before_filter :authenticate_user!, :connect_calendar

  def get_many_google_events(google_events)
    events = []
    google_events.each do |google_event|
      event = Event.new
      event.get_google_event(google_event)
      events.push(event)
    end
    return events
  end

  def connect_calendar()
    @project = Project.find(params[:id])
    @service = GCal4Ruby::Service.new
    @service.authenticate(current_user.username_google_calendar, current_user.password_google_calendar)
    if ((@cal = GCal4Ruby::Calendar.find(@service, {:title => @project.name})).length == 0)
      @cal = GCal4Ruby::Calendar.new(@service, {:title => @project.name})
      @cal.save
    end
    if @cal.length == 1
      @cal = @cal.first
    end
  end

  def index
    events = @cal.events

    @events = get_many_google_events(events)
    respond_to do |format|
      format.html
      format.xml { render :xml => @events }
      format.js { render :json => @events }
    end
  end

  def show
    event = GCal4Ruby::Event.find(@service, {:id => params[:id]})

    @event = Event.new.get_google_event(event)

    respond_to do |format|
      format.html
      format.xml { render :xml => @event }
      format.js { render :json => @event }
    end
  end

  def new
    @event = Event.new()

    respond_to do |format|
      format.html
      format.xml { render :xml => @event }
      format.js { render :json => @event }
    end
  end

  def edit
    @event = GCal4Ruby::Event.find(@service, {:id => params[:id]})

    respond_to do |format|
      format.html
      format.xml { render :xml => @event }
    end
  end

  def create
    @event = Event.new(params[:event])

    event = GCal4Ruby::Event.new(@service, {calendar: @cal, title: @event.title, start_time: @event.start_time.rfc822, :end_time => @event.end_time.rfc822, where: @event.where })
    event.save
    

    # respond_t do |format|
    #     format.html {redirect_to events_url }
    #     format.xml { render :xml => @event }
    # end
  end

  def update
    @event = Event.find(@service, {:id => params[:id]})
  end

end
