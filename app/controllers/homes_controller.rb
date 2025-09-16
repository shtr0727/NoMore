class HomesController < ApplicationController
  def index
    @posts = Post.where(is_draft: false).includes(:streak, :user, :category).order(recorded_on: :desc, created_at: :desc).page(params[:page]).per(6)
  end

  def search
    @query = params[:q]
    
    if @query.present?
      # 投稿内容、理由、ユーザー名、カテゴリー名で検索
      @posts = Post.joins(:user, :category)
                   .where(is_draft: false)
                   .where(
                     "posts.post LIKE ? OR posts.reason LIKE ? OR users.name LIKE ? OR categories.name LIKE ?",
                     "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%"
                   )
                   .includes(:streak, :user, :category)
                   .order(recorded_on: :desc, created_at: :desc)
                   .page(params[:page]).per(6)
      
      # ユーザー検索も実行
      @users = User.where("name LIKE ?", "%#{@query}%")
                   .includes(:posts, :following, :followers)
                   .limit(10)
    else
      @posts = Post.none
      @users = User.none
    end
  end
end
