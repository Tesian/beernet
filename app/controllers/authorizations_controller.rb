class AuthorizationsController < ApplicationController

  def github
    @authorize_url = user_omniauth_authorize_path(:github)
    @create_access = "https://github.com/settings/applications/new"
    render 'new'
  end
  def google
    @authorize_url = user_omniauth_authorize_path(:google)
    @create_access = "https://github.com/settings/applications/new"
    render 'new'
  end
  def dropbox
    @authorize_url = user_omniauth_authorize_path(:dropbox)
    @create_access = "https://www.dropbox.com/login?cont=https%3A//www.dropbox.com/developers/apps"
    render 'new'
  end
end
