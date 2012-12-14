class TodoListsController < ApplicationController

  before_filter :get_project

  def get_project
    @project  = Project.find(params[:project_id])
  end

  def index
    @todo_lists = TodoList.where(project_id: @project.id)

    respond_to do |format|
      format.html
      format.json { render json: @todo_lists }
    end
  end

  def show
    @todo_list = TodoList.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @todo_list}
    end
  end

  def new
    @todo_list = TodoList.new

    respond_to do |format|
      format.html
      format.json { render json: @todo_list}
    end
  end

  def edit
    @todo_list = TodoList.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @todo_list}
    end
  end

  def create
    @todo_list            = TodoList.new(params[:todo_list])
    @todo_list.project_id = @project.id

    respond_to do |format|
      if @todo_list.save
        format.html { redirect_to [@project, @todo_list], notice: 'Todo List was successfully created.' }
        format.json { render json: @todo_list, status: :created, location: [@project, @todo_list] }
      else
        format.html { render action: "new" }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @todo_list = TodoList.find(params[:id])

    respond_to do |format|
      if @todo_list.update_attributes(params[:todo_list])
        format.html { redirect_to [@project, @todo_list], notice: 'Todo List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo_list = TodoList.find(params[:id])
    @todo_list.destroy

    respond_to do |format|
      format.html { redirect_to project_todo_lists_url(@project) }
      format.json { head :no_content }
    end
  end

end
