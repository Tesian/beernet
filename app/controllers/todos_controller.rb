class TodosController < ApplicationController

  def index
    todos = Todo.where(todo_list_id: params[:todo_list_id].to_i)

    respond_to do |format|
      format.json { render :json => todos }
    end
  end

  def create
    todo = Todo.create({body: params[:body]})
    TodoList.find(params[:todo_list_id]}).todos << todo

    respond_to do |format|
      format.json { render :json => todo }
    end
  end

  def update
    todo      = Todo.find(params[:id])
    todo.body = params[:body]
    todo.save

    respond_to do |format|
      format.json { render :json => todo }
    end
  end

  def destroy
    todo = Todo.find(params[:id]).delete

    respond_to do |format|
      format.json { render :json => todo }
    end
  end
end
