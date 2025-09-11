class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = post.id
    if @comment.save
      redirect_to post_path(post), notice: 'コメントを投稿しました'
    else
      @post = Post.find(params[:post_id])
      @comments = @post.comments.includes(:user).order(created_at: :asc)
      render 'posts/show', status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    if comment && (comment.user == current_user || comment.post.user == current_user)
      comment.destroy
      redirect_to post_path(params[:post_id]), notice: 'コメントを削除しました'
    else
      redirect_to post_path(params[:post_id]), alert: 'コメントを削除する権限がありません'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
