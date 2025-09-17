class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:new, :confirm, :create]

  def new
    @reservation = Reservation.new(room: @room)
  end

  # 予約内容確認
  def confirm
    @reservation = current_user.reservations.new(reservation_params.merge(room: @room))

    # --- 必須チェック（空欄なら部屋詳細に戻す） ---
    missing = []
    missing << 'チェックイン日'  if reservation_params[:check_in].blank?
    missing << 'チェックアウト日' if reservation_params[:check_out].blank?
    missing << '人数'            if reservation_params[:guests].blank?

    if missing.any?
      flash.now[:alert] = "#{missing.join('・')}が空欄です。"
      return render 'rooms/show', status: :unprocessable_entity
    end

    # 追加バリデーション（例: チェックアウトはチェックイン以降）
    unless @reservation.valid?
      flash.now[:alert] = @reservation.errors.full_messages.to_sentence
      return render 'rooms/show', status: :unprocessable_entity
    end

    # ここまで来たら confirm.html.erb を表示
    render :confirm
  end

  # 予約確定
  def create
    @reservation = current_user.reservations.new(reservation_params.merge(room: @room))

    if @reservation.save
      redirect_to reservations_path, notice: '予約を確定しました。'
    else
      flash.now[:alert] = @reservation.errors.full_messages.to_sentence
      render :confirm, status: :unprocessable_entity
    end
  end

  def index
    @reservations = current_user.reservations.includes(:room)
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  # form_with の scope: :reservation とペア
  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :guests, :room_id)
  end

  # （使う場合用）金額計算のヘルパ。Modelに total_price があるなら不要
  def calculate_total_amount(reservation)
    raise "Room is not associated with the reservation." if reservation.room.nil?
    nights = reservation.nights
    reservation.room.price * reservation.guests * nights
  end
end
