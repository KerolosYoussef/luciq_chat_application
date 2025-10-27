module Messages
  class SearchService
    def self.call(chat, application, query, page = 1, per_page = 25)
      results = Message.search(
        query,
        where: { chat_id: chat.id },
        page: page,
        per_page: per_page,
        fields: [:body],
        match: :word_start,
        highlight: { tag: '<mark>' }
      )

      {
        query: query,
        current_page: results.current_page,
        per_page: per_page.to_i,
        total_pages: results.total_pages,
        total_count: results.total_count,
        messages: results.map { |message|
          MessageDto.new(message, chat.number, application.token)
        }
      }
    end

  end
end
