class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable 
  #  :validatable

  #validate
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
  validates :name, presence: true, on: :create
  validates :password, presence: true, length: { minimum: 8, maximum: 32 }, on: :create
  validates_confirmation_of :password, on: :create
end
