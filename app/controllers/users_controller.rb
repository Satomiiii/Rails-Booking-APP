class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit_account
    @user = current_user
  end

  def update_account
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'アカウント情報が更新されました'
    else
      render :edit_account
    end
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    if @user.update(profile_params)
      redirect_to user_path(@user), notice: 'プロフィールが更新されました'
    else
      render :edit_profile
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:name, :icon, :introduction) 
  end

  before_action :set_user, only: [:show, :edit, :update, :account, :profile]

  def account
    # アカウントページ表示用の処理
  end

  def profile
    # プロフィールページ表示用の処理
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_user
    @user = current_user
  end
  
end


