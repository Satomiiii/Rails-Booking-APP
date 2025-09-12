# app/controllers/rooms_controller.rb
class RoomsController < ApplicationController
  require 'nkf' # 文字コード正規化用

  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # ===== CRUD =====

  def index
    # 管理者ページなどで使う想定。ログインしていれば自分の施設を、していなければ全件。
    @rooms = current_user ? current_user.rooms : Room.all
  end

  def show
    @reservation = Reservation.new
  end

  def new
    @room = Room.new
    @reservation = Reservation.new
  end

  def create
    # ログインしていない場合でもシード用ユーザーに紐付けて保存できるようにしておく
    owner = current_user || User.first || User.create!(email: "seed@example.com",
                                                      password: "password123",
                                                      name: "Seed User")
    @room = owner.rooms.build(room_params)

    if @room.save
      redirect_to rooms_path, notice: '施設が登録されました。'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @room.update(room_params)
      redirect_to room_path(@room), notice: '施設情報を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path, notice: '施設を削除しました。'
  end

  # ===== 検索 =====
  def search
    area    = params[:area].to_s.strip
    keyword = params[:keyword].to_s.strip

    scope = Room.all
    scope = scope.where("address LIKE ?", "%#{area}%") if area.present?
    scope = scope.where("name LIKE :kw OR description LIKE :kw", kw: "%#{keyword}%") if keyword.present?

    # 画像 N+1 対策
    @rooms = scope.order(created_at: :desc).includes(image_attachment: :blob).load
    @count = @rooms.size

    render :search
  end

  # ===== エリア別インデックス =====
  def tokyo_index
    seed_if_empty('東京', {
      name: 'プリンスホテル',
      address: '東京都港区',
      description: '添い寝用のお布団やおむろ、ベビーチェア、お子様ハンガー、コンセントキャップ、離乳食などを備えた赤ちゃん専用ルームです。ご家族でゆっくりお過ごしください。',
      price: 18000
    })
    @rooms = Room.where("address LIKE ?", "%東京%")
                 .order(created_at: :desc)
                 .includes(image_attachment: :blob)
  end

  def osaka_index
    seed_if_empty('大阪', {
      name: 'ホテルニューオータニ',
      address: '大阪府',
      description: '（大阪の説明）',
      price: 18000
    })
    @rooms = Room.where("address LIKE ?", "%大阪%")
                 .order(created_at: :desc)
                 .includes(image_attachment: :blob)
  end

  def kyoto_index
    seed_if_empty('京都', {
      name: '湯けむりリゾート',
      address: '京都府',
      description: '（京都の説明）',
      price: 18000
    })
    @rooms = Room.where("address LIKE ?", "%京都%")
                 .order(created_at: :desc)
                 .includes(image_attachment: :blob)
  end

  def sapporo_index
    seed_if_empty('札幌', {
      name: '東急ステイ',
      address: '札幌市',
      description: '良いホテル',
      price: 18000
    })
    @rooms = Room.where("address LIKE ?", "%札幌%")
                 .order(created_at: :desc)
                 .includes(image_attachment: :blob)
  end

  private

  # 指定エリアに1件も無ければデフォルトを作成（オーナーはログインユーザー or シードユーザー）
  def seed_if_empty(area_keyword, default_attrs)
    exists = Room.where("address LIKE ?", "%#{area_keyword}%").exists?
    return if exists

    owner = current_user || User.first || User.create!(email: "seed@example.com",
                                                       password: "password123",
                                                       name: "Seed User")
    Room.create!(default_attrs.merge(user: owner))
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image, :area)
  end

  def set_room
    @room = Room.find_by(id: params[:id])
    unless @room
      redirect_to rooms_path, alert: '施設が見つかりませんでした。'
    end
  end
end
