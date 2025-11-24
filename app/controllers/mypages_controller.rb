class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @shops = current_user.shops.order(created_at: :desc)
  end
end
