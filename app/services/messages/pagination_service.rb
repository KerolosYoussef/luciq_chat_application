module Messages
  class PaginationService
    def self.call(chat, application, page = 1, per_page = 25)
      messages = chat.messages
                         .page(page)
                         .per(per_page)

      {
        current_page: messages.current_page,
        per_page: messages.limit_value,
        total_pages: messages.total_pages,
        total_count: messages.total_count,
        messages: messages.map { |message| MessageDto.new(message, chat.number, application.token) }
      }
    end
  end
end