class HomesController < ApplicationController
  def index
    @posts = Post.where(is_draft: false).includes(:streak, :user, :category).order(recorded_on: :desc, created_at: :desc).page(params[:page]).per(6)
  end
end
