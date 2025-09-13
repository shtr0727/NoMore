class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_one :streak, dependent: :destroy

  # 投稿のストリークを取得または作成
  def current_streak
    streak || create_streak!(
      user: user,
      post: self,
      date: recorded_on || Date.current,  # 投稿の記録日を使用
      status: Streak::STATUS_ACTIVE
    )
  end

  # ストリークをリセット（投稿編集時）
  def reset_streak!
    current_streak.reset!
  end

  # ストリークの継続日数を取得
  def streak_count
    current_streak.current_count
  end

  # ストリークの状態を取得
  def streak_status
    current_streak.status
  end
end
