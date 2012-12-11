class AccessesController < ApplicationController
  before_filter :authenticate_user!, :get_project

  def get_project
    @project  = Project.find(params[:project_id])
  end

  def index
    @accesses = Access.where(project_id: @project.id)

    respond_to do |format|
      format.html
      format.json { render json: @accesses }
    end
  end

  def show
    @access  = Access.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @access }
    end
  end

  def new
    @access  = Access.new

    respond_to do |format|
      format.html
      format.json { render json: @access }
    end
  end

  def edit
    @access = Access.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @access }
    end
  end

  def create
    @access            = Access.new(params[:access])
    @access.project_id = @project.id
    respond_to do |format|
      if @access.save
        format.html { redirect_to [@project, @access], notice: 'Access was successfully created.' }
        format.json { render json: @access, status: :created, location: [@project, @access] }
      else
        format.html { render action: "new" }
        format.json { render json: @access.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @access = Access.find(params[:id])

    respond_to do |format|
      if @access.update_attributes(params[:access])
        format.html { redirect_to [@project, @access], notice: 'Access was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @access.errors, status: :unprocessable_entity }
      end
    end
  end

    def destroy
    @access = Access.find(params[:id])
    @access.destroy

    respond_to do |format|
        format.html { redirect_to project_accesses_url(@project) }
        format.json { head :no_content }
    end
  end

end
