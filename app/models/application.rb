class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  validates :token, presence: true, uniqueness: true
  validates :chats_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
