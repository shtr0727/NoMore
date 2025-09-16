class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
    set_categories
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    
    if @post.save
      # 投稿作成時にその投稿のストリークを作成
      @post.current_streak
      redirect_to home_path, notice: '投稿が作成されました'
    else
      set_categories
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @post は set_post で設定済み
    @comments = @post.comments.includes(:user).order(created_at: :asc)
    @comment = Comment.new
    
    # ストリークが存在しない場合は作成
    @post.current_streak
  end

  def edit
    # @post は set_post で設定済み
    set_categories
    
    # ストリークが存在しない場合は作成
    @post.current_streak
  end

  def update
    # 変更前のrecorded_onを保存（日付変更の検知用）
    original_recorded_on = @post.recorded_on
    
    post_params_with_draft_status = post_params.dup
    if params[:commit_publish]
      post_params_with_draft_status[:is_draft] = false
    elsif params[:commit_draft]
      post_params_with_draft_status[:is_draft] = true
    end

    # うっかりリセットがチェックされている場合、recorded_onを今日の日付に変更
    if params[:post][:reset_streak] == "true"
      post_params_with_draft_status[:recorded_on] = Date.current
    end

    # 日付が空の場合のエラーハンドリング
    if post_params_with_draft_status[:recorded_on].blank?
      @post.errors.add(:recorded_on, "を入力してください")
      set_categories
      render :edit, status: :unprocessable_entity
      return
    end

    # reset_streakはPostの属性ではないので除外
    post_params_with_draft_status.delete(:reset_streak)

    if @post.update(post_params_with_draft_status)
      # recorded_onが変更された場合、ストリークの基準日も更新
      if original_recorded_on != @post.recorded_on
        @post.update_streak_date!
        @post.reload
      end
      
      notice_message = '投稿が更新されました'
      if params[:post][:reset_streak] == "true"
        notice_message += '（継続記録をリセットしました）'
      elsif original_recorded_on != @post.recorded_on
        notice_message += "（日付が#{original_recorded_on}から#{@post.recorded_on}に変更され、継続日数は#{@post.streak_count}日になりました）"
      end
      redirect_to @post, notice: notice_message
    else
      set_categories # エラー時にもカテゴリを再取得
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

  def set_categories
    @categories = Category.all
  end
end
