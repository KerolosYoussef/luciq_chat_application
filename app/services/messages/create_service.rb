module Messages
  class CreateService
    def self.call(application, chat, body)
      # get message number from redis before adding it
      message_number = REDIS.incr("application:#{application.token}:#{chat.number}:message_counter")

      # add the job to sidekiq/redis to be executed
      MessageCreationJob.perform_later(chat.id, message_number, body)

      # return the message result with the token, chat number, body, and message number
      {
        message_number: message_number,
        body: body,
        application_token: application.token,
        chat_number: chat.number
      }
    end
  end
end