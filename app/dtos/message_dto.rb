class MessageDto
  def initialize(message, chat_number, application_token)
    @message = message
    @chat_number = chat_number
    @application_token = application_token
  end

  def as_json(*)
    {
      body: @message.body,
      message_number: @message.number,
      chat_number: @chat_number,
      application_token: @application_token
    }
  end
end
