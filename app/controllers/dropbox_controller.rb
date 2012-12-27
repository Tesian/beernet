class DropboxController < ApplicationController
  def new
    render
  end
  def authorize
    Dropbox::API::Config.app_key    = params[:app_key]
    Dropbox::API::Config.app_secret = params[:app_secret]
    Dropbox::API::Config.mode       = "sandbox"
    consumer                        = Dropbox::API::OAuth.consumer(:authorize)
    request_token                   = consumer.get_request_token 
    @authorize_url                  = request_token.authorize_url(:oauth_callback => dropbox_confirm_url)

    cookies[:app_key]    = { value: params[:client_id], expires: Time.now + 600}
    cookies[:app_secret] = { value: params[:client_secret], expires: Time.now + 600}

    render
  end
  def confirm
    Dropbox::API::Config.app_key    = cookies[:app_key]
    Dropbox::API::Config.app_secret = cookies[:app_secret]
    Dropbox::API::Config.mode       = "sandbox"
    consumer                        = Dropbox::API::OAuth.consumer(:authorize)
    request_token                   = consumer.get_request_token    

    result = request_token.get_access_token(:oauth_verifier => params[:oauth_token])

    current_user.dropbox_oauth_token = result.token
    current_user.dropbox_secret      = result.secret

    cookies.delete :app_key
    cookies.delete :app_secret

    redirect_to projects_path
  end
end
