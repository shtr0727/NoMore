class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
    @categories = Category.all
    @streaks = Streak.all # 必要に応じてcurrent_userのstreaksに変更可
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @categories = Category.all
    @streaks = Streak.all
    if @post.save
      redirect_to home_path, notice: '投稿が作成されました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:post, :reason, :category_id, :is_draft, :recorded_on)
  end
end
