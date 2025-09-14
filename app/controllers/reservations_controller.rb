class ReservationsController < ApplicationController
  before_action :set_room, only: [:new, :create]

  def new
    @reservation = Reservation.new(
      room:    @room,
      check_in:  params[:check_in],
      check_out: params[:check_out],
      guests:    params[:guests]
    )
  end

  # 予約内容確認
  def confirm
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(reservation_params.merge(room: @room, user: current_user))

    # バリデーション NG のときは new を再表示
    unless @reservation.valid?
      flash.now[:alert] = @reservation.errors.full_messages.to_sentence
      render :new and return
    end

    @reservation.total_amount = calculate_total_amount(@reservation)
    render :confirm
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = current_user.reservations.new(reservation_params.merge(room: @room))

    if @reservation.save
      redirect_to reservations_path, notice: '予約が確定しました。'
    else
      flash.now[:alert] = @reservation.errors.full_messages.to_sentence
      render :new
    end
  end

  def index
    @reservations = current_user.reservations.includes(:room)
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :guests, :room_id)
  end

  def calculate_total_amount(reservation)
    raise "Room is not associated with the reservation." if reservation.room.nil?
    nights = reservation.nights
    nights * reservation.room.price * reservation.guests
  end
end
