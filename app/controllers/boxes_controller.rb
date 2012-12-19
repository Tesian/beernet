class BoxesController < ApplicationController
  before_filter :get_project

  def get_project
    @project = Project.find(params[:project_id])
  end

  def index
    @boxes = Box.where(project_id: @project.id)
    
    respond_to do |format|
      format.html
      format.xml { render :xml =>  @boxes }
      format.js  { render :json => @boxes }
    end
  end
  def show
    @box = Box.find(params[:id])

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
    @box = Box.new({username: params[:username]})
    @box.project_id = @project.id

    session = Dropbox::Session.new(params[:username], params[:password])
    session.mode = :sandbox
    @authorize_url = session.authorize_url

    render html
      # respond_to do |format|
      #   if @box.save
      #     format.html { redirect_to [@project, @box], notice: 'Box was successfully created.' }
      #     format.json { render json: @box, status: :created, location: [@project, @box] }
      #   else
      #     format.html { render action: "new" }
      #     format.json { render json: @box.errors, status: :unprocessable_entity }
      #   end
      # end
    # end
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
