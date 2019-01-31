class User < ApplicationRecord
  validates_presence_of :first_name
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
