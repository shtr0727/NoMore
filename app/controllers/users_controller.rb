class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(is_draft: false).order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile)
  end
end
