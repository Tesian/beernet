class IssuesController < ApplicationController
  before_filter :authenticate_user!

  def get_issues
    @project = Project.find(params[:project_id])
    issue = Github::Issues.new
    issues = issue.list_repo("#{current_user.username_github}", "#{@project.name}")
  end

  def index
    
  end

  def show
    
  end

  def new
    @issue = Issue.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @event }
      format.js { render :json => @event }
    end
  end

  def edit
    
  end

  def create
    
  end

  def update
  end

  def destroy
  end
end
