class Message < ApplicationRecord
  searchkick word_start: [:body], highlight: [:body]

  belongs_to :chat
  validates :number, presence: true, uniqueness: { scope: :chat_id }
  
  def search_data
    {
      body: body,
      chat_id: chat_id,
      number: number,
      created_at: created_at
    }
  end
end
