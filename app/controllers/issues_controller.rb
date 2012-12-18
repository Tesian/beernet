# -*- coding: utf-8 -*-
class IssuesController < ApplicationController
  before_filter :get_issues
  before_filter :get_issue_with_id, :only => [:show, :edit, :update, :destroy]
  before_filter :make_issue_with_hash_github, :only => [:show, :edit]

  def get_issues
    @project = Project.find(params[:project_id])
    accesses = @project.accesses
    @access  = nil
    accesses.each do | access |
      if access.genre == "git"
        @access        = access
        @api           = Github.new basic_auth: "#{current_user.username_github}:#{current_user.password_github}"
        @issues_github = @api.issues.list user:"#{access.login}", repo: "#{access.repo_name}"
      end
    end
    if @access == nil
      flash[:notice] = "Il n'y a pas d'acces github"
      redirect_to new_project_access_path(@project)
    end
  end

  def get_issue_with_id
    @issues_github.each do | issue |
      if issue.number == params[:id].to_i
        @issue_hash = issue
      end
    end
  end

  def make_issue_with_hash_github
    @issue = Issue.new
    @issue.get_issue(@issue_hash)
    if @issue == nil
      flash[:notice] = "Il n'y a pas d'issue de ce numéro."
      redirect_to project_issues_path(@project)
    end
  end

  def index
    @issues = []
    @issues_github.each do | issue |
      new_issue = Issue.new
      new_issue.get_issue(issue)
      @issues.push(new_issue)
    end

    respond_to do |format|
      format.html
      format.xml { render :xml =>  @issues }
      format.js  { render :json => @issues }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render :xml =>  @issue }
      format.js  { render :json => @issue }
    end
  end

  def new
    @issue           = Issue.new

    respond_to do |format|
      format.html
      format.xml { render :xml =>  @issue }
      format.js  { render :json => @issue }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.xml { render :xml =>  @issue }
      format.js  { render :json => @issue }
    end
  end

  def create
    issue = params[:issue]
    @issue = @api.issues.create @access.login, @access.repo_name, :title => issue[:title], :body => issue[:body], :assignee => issue[:assignee], :milestone => issue[:milestone], :labels => issue[:labels].delete("[]\" ").split(",")
      
    respond_to do |format|
      format.html { redirect_to     project_issue_path(@project, @issue.number) }
      format.xml  { render :xml =>  @issue }
      format.js   { render :json => @issue }
    end
  end

  def update
    @api.issues.edit @access.login, @access.repo_name, @issue_hash.id, title: params[:issue][:title]

    respond_to do |format|
      format.html { redirect_to     project_issue_path(@project, @issue_hash.number) }
      format.xml  { render :xml =>  @issue }
      format.js   { render :json => @issue }
    end
  end

  def destroy
    @api.issues.edit @access.login, @access.repo_name, @issue_hash.id, state: "closed"

    respond_to do |format|
      format.html { redirect_to     project_issues_path(@project) }
      format.xml  { render :xml =>  @issue }
      format.js   { render :json => @issue }
    end
  end
end
