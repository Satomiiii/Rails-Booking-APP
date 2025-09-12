class Room < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, :description, :price, :address, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 }
  has_many :reservations, dependent: :destroy

  before_save :normalize_text_fields

 private

 def normalize_text_fields
   self.address = normalize(address)
   self.name = normalize(name)
   self.description = normalize(description)
 end

 def normalize(text)
   return nil if text.blank?
   text = NKF.nkf('-w -Z1', text) # 全角→半角統一
   text.gsub(/[[:space:]]|\u3000|\r|\n|\t/, '').strip
 end

end