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
      if access.type_accesses[0] != nil && access.type_accesses[0].name == "github"
        @access        = access
        Github.new basic_auth: "#{current_user.username_github}:#{current_user.password_github}"
        @issues_github = Github::Issues.new.list_repo("#{access.login}", "#{access.repo_name}")
      end
    end
    if @access == nil
      flash[:notice] = "Il n'y a pas d'acces github"
      redirect_to @project
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
