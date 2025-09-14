class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # 基本バリデーション
  validates :check_in, :check_out, :guests, presence: true
  validates :guests, numericality: { only_integer: true, greater_than: 0 }

  # 「チェックアウトはチェックインより後」バリデーション
  validate :check_out_after_check_in

  # 泊数のヘルパ（必要に応じて使えます）
  def nights
    return 0 if check_in.blank? || check_out.blank?
    (check_out.to_date - check_in.to_date).to_i
  end

  private

  def check_out_after_check_in
    return if check_in.blank? || check_out.blank?
    if check_out <= check_in
      errors.add(:check_out, 'はチェックインの翌日以降を選択してください')
    end
  end
end
