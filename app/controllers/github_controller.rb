class GithubController < ApplicationController

  def new
    render
  end

  def authorize
    api            = Github.new :client_id => params[:client_id], :client_secret => params[:client_secret]
    @authorize_url = api.authorize_url :redirect_uri => github_confirm_url, :scope => 'repo'

    cookies[:client_id]     = { value: params[:client_id], expires: Time.now + 600}
    cookies[:client_secret] = { value: params[:client_secret], expires: Time.now + 600}

    render
  end

  def confirm
    
    api = Github.new :client_id => cookies[:client_id], :client_secret => cookies[:client_secret]

    current_user.github_oauth_token = api.get_token(params[:code])

    cookies.delete :client_id
    cookies.delete :client_secret

    redirect_to projects_path
  end
end
