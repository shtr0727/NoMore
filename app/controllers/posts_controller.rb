class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

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

  def show
    # @post は set_post で設定済み
  end

  def edit
    # @post は set_post で設定済み
    @categories = Category.all
  end

  def update
    post_params_with_draft_status = post_params.dup
    if params[:commit_publish]
      post_params_with_draft_status[:is_draft] = false
    elsif params[:commit_draft]
      post_params_with_draft_status[:is_draft] = true
    end

    if @post.update(post_params_with_draft_status)
      redirect_to @post, notice: '投稿が更新されました'
    else
      @categories = Category.all # エラー時にもカテゴリを再取得
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to home_path, notice: '投稿が削除されました'
  end

  def drafts
    @draft_posts = current_user.posts.where(is_draft: true).order(created_at: :desc)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:post, :reason, :category_id, :is_draft, :recorded_on)
  end
end
