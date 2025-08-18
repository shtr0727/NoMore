class HomesController < ApplicationController
  def index
    @posts = Post.where(is_draft: false).order(created_at: :desc).page(params[:page]).per(6)
  end
end
