# frozen_string_literal: true
module Chats
  class PaginationService
    def self.call(application, page = 1, per_page = 25)
      chats = application.chats
                         .page(page)
                         .per(per_page)

      {
        current_page: chats.current_page,
        per_page: chats.limit_value,
        total_pages: chats.total_pages,
        total_count: chats.total_count,
        chats: chats.map { |chat| ChatDto.new(chat, application.token) }
      }
    end
  end
end
