class ChatDto
  def initialize(chat, application_token)
    @chat = chat
    @application_token = application_token
  end

  def as_json(*)
    {
      number: @chat.number,
      messages_count: @chat.messages_count,
      application_token: @application_token,
    }
  end
end
