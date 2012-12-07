# -*- coding: utf-8 -*-
class IssuesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_issues
  before_filter :get_issue_with_id, :only => [:show, :edit, :update, :destroy]
  before_filter :make_issue_with_hash_github, :only => [:show, :edit]

  def get_issue_with_id
    issues.each do | issue |
      if issue.number == params[:id]
        @issue_hash = issue
      end
    end
  end

  def make_issue_with_hash_github
    @issue = Issue.new.get_issue(@issue_hash)
    if @issue == nil
      flash[:notice] = "Il n'y a pas d'issue de ce numéro."
      redirect_to project_issues_path(@project)
    end
  end

  def get_issues
    @project = Project.find(params[:project_id])
    accesses = @project.accesses
    accesses.each do | access |
      if access.type_access.name == "github"
        @access = access
        Github.new basic_auth: "#{access.login}:#{access.password}"
        issues  = Github::Issues.new.list_repo("#{access.login}", "#{access.repo_name}")
      end
    end
    if issues == nil
      flash[:notice] = "Il n'y a pas d'acces github"
      redirect_to @project
    end
  end

  def index
    @issues = []
    issues.each do | issue |
      @issues.push(Issue.new.get_issue(issue))
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
    @issue = Issue.new

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
    Github::Issues.create(current_user.username_github, @access.repo_name, params[:issue])

    respond_to do |format|
      format.html { redirect_to     @project }
      format.xml  { render :xml =>  @issue }
      format.js   { render :json => @issue }
    end
  end

  def update
    @issue_hash.edit(@access.login, @access.repo_name, @issue_hash.id, params[:issue])

    respond_to do |format|
      format.html { redirect_to     @project }
      format.xml  { render :xml =>  @issue }
      format.js   { render :json => @issue }
    end
  end

  def destroy
    @issue_hash.edit(@access.login, @access.repo_name, @issue_hash.id, {state: "closed"})

    respond_to do |format|
      format.html { redirect_to     @project }
      format.xml  { render :xml =>  @issue }
      format.js   { render :json => @issue }
    end
  end
end
