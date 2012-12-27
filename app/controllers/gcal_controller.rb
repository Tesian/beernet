class GcalController < ApplicationController
  def new
  end
  def authorize
    @authorize_url = GData::Auth::AuthSub.get_url(gcal_confirm_url, 'http://www.google.com/calendar/feeds/', false, true)

    render
  end
  def confirm
  end
end
