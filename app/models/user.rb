class User < ApplicationRecord
  has_secure_password
  has_many :spreadsheets, dependent: :destroy

  validates :email, presence: true,
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true
end
