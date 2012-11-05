module ClientsHelper

  def setup_client(client)
    if client.contacts.length == 0
      client.contacts[0] = Contact.new
    end
    client
  end

end
