# -*- coding: utf-8 -*-
class EventsController < ApplicationController

  before_filter :connect_calendar

  def connect_calendar
    @project = Project.find(params[:project_id])
    @service = GCal4Ruby::Service.new

    # Connexion à google calendar avec l'user authentifié
    @service.authenticate(current_user.username_google_calendar, current_user.password_google_calendar)

    # Si aucun calendrier n'existe aux noms du projets le créer (il sera selectionné si il existe)
    if ((@cal = GCal4Ruby::Calendar.find(@service, {:title => @project.name})).length == 0)
      @cal = GCal4Ruby::Calendar.new(@service, {:title => @project.name})
      @cal.save
    end

    # Le résultat étant dans un array on récupère le premier
    if @cal.length == 1
      @cal = @cal.first
    end
  end

  def index
    events_gcal    = @cal.events

    if params[:start] && params[:end]
      # Récupération des paramètres de temps s'il existent et récupération d'un objet Time correspondant aux paramètres transmis
      start_time  = Time.at(params[:start].to_i)
      end_time    = Time.at(params[:end].to_i)
    end

    @events       = get_many_google_events(events_gcal, end_time, start_time)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @events }
      format.js   { render :json => @events }
    end
  end

  def show
    events_gcal = @cal.events
    events      = get_many_google_events(events_gcal, nil, nil)
    @event      = events[params[:id].to_i]

    respond_to do |format|
      format.html
      format.xml  { render :xml => @event }
      format.js   { render :json => @event }
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @event }
      format.js  { render :json => @event }
    end
  end

  def edit
    events_gcal = @cal.events
    events      = get_many_google_events(events_gcal, nil, nil)
    @event      = events[params[:id].to_i]

    respond_to do |format|
      format.html
      format.xml { render :xml => @event }
    end
  end

  def create
    event      = params[:event]

    start_time = Time.new(event[:start_time][:year], event[:start_time][:month], event[:start_time][:day], event[:start_time][:hours], event[:start_time][:mins])
    end_time   = Time.new(event[:end_time][:year], event[:end_time][:month], event[:end_time][:day], event[:end_time][:hours], event[:end_time][:mins])

    new_event  = GCal4Ruby::Event.new(@service, {calendar: @cal, title: event[:title], start_time: start_time, :end_time => end_time, where: event[:where], content: event[:description]})

    respond_to do |format|
      if new_event.save
        format.html {redirect_to project_events_url(@project) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    events_gcal            = @cal.events
    events                 = get_many_google_events(events_gcal, nil, nil)
    ap events[params[:id].to_i]
    event_gcal             = get_google_event_by_event(events[params[:id].to_i], events_gcal)
    event                  = params[:event]

    if event_gcal == nil
      flash[:notice]       = "L'event google n'a pas pu être trouvé."
      redirect_to project_events_url(@project)
    end
    ap event_gcal

    event_gcal.start_time = Time.new(event[:start_time][:year], event[:start_time][:month], event[:start_time][:day], event[:start_time][:hours], event[:start_time][:mins])
    event_gcal.end_time   = Time.new(event[:end_time][:year], event[:end_time][:month], event[:end_time][:day], event[:end_time][:hours], event[:end_time][:mins])
    event_gcal.title      = event[:title]
    event_gcal.where      = event[:where]
    event_gcal.content    = event[:description]

    respond_to do |format|
      if event_gcal.save
        format.html { redirect_to(project_event_path(@project, params[:id]), :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
        format.js { head :ok}
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    events_gcal      = @cal.events
    events           = get_many_google_events(events_gcal, nil, nil)
    event_gcal       = get_google_event_by_event(events[params[:id].to_i], events_gcal)

    if event_gcal == nil
      flash[:notice] = "L'event google n'a pas pu être trouvé."
      redirect_to project_events_url(@project)
    end

    event_gcal.title      = "DELETED"
    event_gcal.content    = ""
    event_gcal.where      = ""
    event_gcal.start_time = Time.parse("2005-01-01 00:00")
    event_gcal.end_time   = Time.parse("2005-01-01 00:00")
    event_gcal.save

    respond_to do |format|
      format.html { redirect_to project_events_url(@project) }
      format.xml  { head :ok }
    end
  end

  # fonction qui récupère les events en object calendar et les mets dans des objets event
  def get_many_google_events(google_events, end_time = nil, start_time = nil)
    events = []
    i = 0
    google_events.each do |google_event|
      event = Event.new
      event.get_google_event(google_event)
      event.id = i

      # si les paramètres de temps sont présent les prendre en compte
      if end_time && start_time
        # Ne pas prendre les éléments détruit et les éléments ne correspondant pas aux paramètres de temps transmis
        if event.title != "DELETED" && event.start_time > start_time && event.end_time < end_time          
          events.push(event)
          i = i + 1
        end
      else
        # Ne pas prendre les éléments détruit et les éléments datant de plus de 5 jours dans le passé
        if event.title != "DELETED" && event.start_time > Time.now - 25920000
          events.push(event)
          i = i + 1
        end
      end
    end

    return events
  end

  # Prend le google event correspondant au event donné
  def get_google_event_by_event(event, events_gcal)
    @event_gcal = nil
    events_gcal.each do |event_gcal|
      if event_gcal.title == event.title && event_gcal.content == event.description && event_gcal.where == event.where
        return event_gcal
      end
    end
    return nil
  end

end
