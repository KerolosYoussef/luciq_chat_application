module Chats
  class CreateService
    def self.call(application)
      # get chat number from redis before adding it
      chat_number = REDIS.incr("application:#{application.token}:chat_counter")

      # add the job to sidekiq/redis to be executed
      ChatCreationJob.perform_later(application.id, chat_number)

      # return the chat result with the token and chat number
      {
        application_token: application.token,
        chat_number: chat_number,
        messages_count: 0
      }
    end
  end
end
