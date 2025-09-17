class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # /users/:id
  def show; end

  # /users/:id/account（メール/パスワード表示）
  def account; end

  # /users/:id/profile（プロフィール表示）
  def profile; end

  # /users/:id/edit_profile（編集フォーム表示）
  def edit_profile; end

  # PATCH /users/:id/update_profile（更新）
  def update_profile
    if @user.update(profile_params)
      redirect_to account_user_path(@user), notice: 'プロフィールを更新しました。'
    else
      render :edit_profile
    end
  end

  # （メール/パスワード編集は Devise 画面に委譲）
  def edit_account
    redirect_to edit_user_registration_path
  end

  def update_account
    redirect_to edit_user_registration_path
  end

  private

  def set_user
    # 自分以外のページを弾く
    @user = current_user
    if params[:id].present? && @user.id.to_s != params[:id].to_s
      redirect_to root_path, alert: '権限がありません'
    end
  end

  # ★ self_introduction を許可（ここがポイント）
  def profile_params
    params.require(:user).permit(:name, :icon, :self_introduction)
  end
end
