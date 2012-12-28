OmniAuth.config.full_host = "http://localhost:3000"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google, 'domain.com', 'oauth_secret', :scope => 'http://www.google.com/calendar/feeds/'
  provider :github, params[:app_key], params[:app_secret], scope: "repo"
  provider :dropbox, params[:app_key], params[:app_secret]
end

