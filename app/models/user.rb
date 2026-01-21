class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true, length: { maximum: 100 }
  validates :email_address, presence: true, length: { maximum: 255 },
                            format: { with: URI::MailTo::EMAIL_REGEXP },
                            uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
