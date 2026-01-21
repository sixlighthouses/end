class Note < ApplicationRecord
  belongs_to :todo

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  default_scope -> { order(created_at: :desc) }
end
