class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  
  has_one_attached :icon

  has_many :reservations, dependent: :destroy
  has_many :rooms, dependent: :destroy
  

end
