class MessageCreationJob < ApplicationJob
  def perform(chat_id, message_number, body)
    ApplicationRecord.transaction do
      # add new message
      Message.create!(chat_id: chat_id, number: message_number, body: body)

      # increment messages_count in chat
      Chat.increment_counter(:messages_count, chat_id)
    end
    
  end
end