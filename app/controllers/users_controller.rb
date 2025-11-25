class UsersController < ApplicationController
  layout 'application'
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to mypage_path, notice: 'プロフィールを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # アイコン任意
    params.require(:user).permit(:name, :icon)
  end
end
