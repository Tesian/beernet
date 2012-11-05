class ClientsController < ApplicationController
include Coast

  respond_to :destroy do
    respond_to do |format|
      format.html { redirect_to clients_url }
      format_json_and_xml(format, @resourceful_item)
    end
  end
end
