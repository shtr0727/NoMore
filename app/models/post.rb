class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_one :streak, dependent: :destroy
  # バッジは動的に計算（永続化しない）

  # 投稿のストリークを取得または作成
  def current_streak
    streak || create_streak!(
      user: user,
      post: self,
      date: recorded_on || Date.current  # 投稿の記録日を使用
    )
  end

  # ストリークの継続日数を取得
  def streak_count
    current_streak.current_count
  end

  # ストリークの状態を取得
  def streak_status
    current_streak.status
  end
  
  # アクティブな継続状態かどうか
  def streak_active?
    current_streak.active?
  end
  
  # 投稿の日付変更時にストリークの基準日も更新
  def update_streak_date!
    return unless streak
    
    # 既存のストリークがある場合、recorded_onの変更に合わせて基準日を更新
    streak.update_date_from_post!
  end
  
  # 現在の継続日数に応じた獲得バッジを動的に取得
  def current_badges
    current_streak_count = streak_count
    return Badge.none unless current_streak_count > 0
    
    Badge.streak_badges.where('required_days <= ?', current_streak_count).order(:required_days)
  end
  
  # バッジを取得（動的計算のため、current_badgesと同じ）
  def badges
    current_badges
  end
end
