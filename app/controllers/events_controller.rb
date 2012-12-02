# -*- coding: utf-8 -*-
class EventsController < ApplicationController

  before_filter :authenticate_user!, :connect_calendar

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
        if event.title != "deleted" && event.start_time > start_time && event.end_time < end_time          
          events.push(event)
          i = i + 1
        end
      else
        # Ne pas prendre les éléments détruit et les éléments datant de plus de 5 jours dans le passé
        if event.title != "deleted" && event.start_time > Time.now - 25920000
          events.push(event)
          i = i + 1
        end
      end
    end

    return events
  end

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
    events        = @cal.events

    if params[:start] && params[:end]
      # Récupération des paramètres de temps s'il existent et récupération d'un objet Time correspondant aux paramètres transmis
      start_time  = Time.at(params[:start].to_i)
      end_time    = Time.at(params[:end].to_i)
    end

    @events       = get_many_google_events(events, end_time, start_time)

    respond_to do |format|
      format.html
      format.xml        { render :xml => @events }
      format.js         { render :json => @events }
    end
  end

  def show
    events    = @cal.events
    event     = events[params[:id].to_i]

    @event    = Event.new
    @event.get_google_event(event)
    @event.id = params[:id].to_i

    respond_to do |format|
      format.html
      format.xml        { render :xml => @event }
      format.js         { render :json => @event }
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
    events    = @cal.events
    event     = events[params[:id].to_i]

    @event    = Event.new
    @event.id = params[:id].to_i
    @event.get_google_event(event)

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
    events                  = @cal.events
    event_update            = events[params[:id].to_i]
    event                   = params[:event]

    event_update.start_time = Time.new(event[:start_time][:year], event[:start_time][:month], event[:start_time][:day], event[:start_time][:hours], event[:start_time][:mins])
    event_update.end_time   = Time.new(event[:end_time][:year], event[:end_time][:month], event[:end_time][:day], event[:end_time][:hours], event[:end_time][:mins])
    event_update.title      = event[:title]
    event_update.where      = event[:where]
    event_update.content    = event[:description]

    respond_to do |format|
      if event_update.save
        format.html { redirect_to(project_event_path(@project, params[:id]), :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
        format.js { head :ok}
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    events           = @cal.events
    event            = events[params[:id].to_i]

    event_update.title      = "DELETED"
    event_update.content    = ""
    event_update.where      = ""
    event_update.start_time = Time.parse("2005-01-01 00:00")
    event_update.end_time   = Time.parse("2005-01-01 00:00")
    event_update.save

    respond_to do |format|
      format.html { redirect_to project_events_url(@project) }
      format.xml  { head :ok }
    end
  end

end
