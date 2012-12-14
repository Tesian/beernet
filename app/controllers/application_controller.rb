class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || "/projects"
  end

  protect_from_forgery
end
