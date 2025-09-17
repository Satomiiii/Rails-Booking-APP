class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # 基本バリデーション
  validates :check_in, :check_out, :guests, presence: true
  validates :guests, numericality: { only_integer: true, greater_than: 0 }

  # チェックアウトはチェックイン以降
  validate :check_out_after_check_in

  # 予約確定日時が空なら作成時に自動セット
  before_create :set_confirmed_at

  # ===== 便利メソッド =====

  # 泊数（Date/Timeの差異の影響を避けるため to_date に統一）
  def nights
    return 0 if check_in.blank? || check_out.blank?
    (check_out.to_date - check_in.to_date).to_i
  end

  # 合計金額
  def total_price
    return 0 if room.nil?
    room.price.to_i * guests.to_i * nights
  end

  # 表示用（yyyy/mm/dd）
  def check_in_ymd
    check_in&.to_date&.to_s(:ymd)
  end

  def check_out_ymd
    check_out&.to_date&.to_s(:ymd)
  end

  # 予約確定日時（yyyy/mm/dd HH:MM, JST）
  def confirmed_at_ymdhm
    t = confirmed_at || created_at
    t&.in_time_zone('Tokyo')&.to_s(:ymd_hm)
  end

  private

  def check_out_after_check_in
    return if check_in.blank? || check_out.blank?
    if check_out.to_date <= check_in.to_date
      errors.add(:check_out, 'はチェックインの翌日以降を選択してください')
    end
  end

  def set_confirmed_at
    self.confirmed_at ||= Time.current
  end
end
