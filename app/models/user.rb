class User < ApplicationRecord
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :comments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :validatable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable,
         :timeoutable

  # validate
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
  # on create
  validates :email, uniqueness: { case_sensitive: false }, on: :create
  validates :name, presence: true, on: :create
  validates :password, length: { minimum: 8, maximum: 32 }, on: :create
  validates_confirmation_of :password, on: :create
  # Validate for password reset
  validates :password, length: { minimum: 8, maximum: 32 }, if: :password_present?
  validates_confirmation_of :password, if: :password_present?

  # Ensure password is present when validating
  def password_present?
    password.present?
  end
end
