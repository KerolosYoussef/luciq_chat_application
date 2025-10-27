class ChatCreationJob < ApplicationJob
  def perform(application_id, chat_number)
    ApplicationRecord.transaction do
      # add new chat
      Chat.create!(application_id: application_id, number: chat_number)

      # increment chats_count in application
      Application.increment_counter(:chats_count, application_id)
    end
  end
end
