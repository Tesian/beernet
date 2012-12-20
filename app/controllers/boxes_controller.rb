# -*- coding: utf-8 -*-
class BoxesController < ApplicationController
  before_filter :get_project

  def get_project
    @project = Project.find(params[:project_id])
  end

  def index
    @boxes = Box.where(project_id: @project.id)

    if params[:oauth_token] != nil
      box = Box.last
      box.auth_token = params[:oauth_token]
      box.save
      flash[notice] = "Autorisation bien effectuée"
    end
    
    respond_to do |format|
      format.html
      format.xml { render :xml =>  @boxes }
      format.js  { render :json => @boxes }
    end
  end
  def show
    @box = Box.find(params[:id])
    @client = Dropbox::API::Client.new :token => @box.auth_token, :secret => @box.app_secret

    respond_to do |format|
      format.html
      format.xml { render :xml =>  @box }
      format.js  { render :json => @box }
    end
  end
  def new
    @box = Box.new

    respond_to do |format|
      format.html
      format.xml { render :xml =>  @box }
      format.js  { render :json => @box }
    end
  end
  def edit
    @box = Box.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml =>  @box }
      format.js  { render :json => @box }
    end
  end
  def create
    @box = Box.new({app_name: params[:app_name], app_secret: params[:app_secret]})
    @box.project_id = @project.id

    Dropbox::API::Config.app_key    = params[:app_key]
    Dropbox::API::Config.app_secret = params[:app_secret]
    Dropbox::API::Config.mode       = "sandbox"
    consumer                        = Dropbox::API::OAuth.consumer(:authorize)
    request_token                   = consumer.get_request_token
    @authorize_url = request_token.authorize_url(:oauth_callback => request.url)
    @box.save

    render
  end

  def update
    @box = Box.find(params[:id])

    respond_to do |format|
      if @box.update_attributes(params[:box])
        format.html { redirect_to [@project, @box], notice: 'Box was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @box = Box.find(params[:id])
    @box.destroy

    respond_to do |format|
      format.html { redirect_to project_boxes_url(@project) }
      format.json { head :no_content }
    end
  end
end
