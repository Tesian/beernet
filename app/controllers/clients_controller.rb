class ClientsController < ApplicationController
include Coast

  before_filter :authenticate_user!

  respond_to :destroy do
    respond_to do |format|
      format.html { redirect_to clients_url }
      format_json_and_xml(format, @resourceful_item)
    end
  end
end
