class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_one :streak, dependent: :destroy

  # バリデーション
  validates :recorded_on, presence: { message: "を入力してください" }

  # 投稿のストリークを取得または作成
  def current_streak
    return nil unless recorded_on  # recorded_onがnilの場合はnilを返す
    
    streak || create_streak!(
      user: user,
      post: self,
      date: recorded_on
    )
  end

  # ストリークの継続日数を取得
  def streak_count
    streak = current_streak
    streak ? streak.current_count : 0
  end

  # アクティブな継続状態かどうか
  def streak_active?
    streak = current_streak
    streak ? streak.active? : false
  end
  
  
  # 現在の継続日数に応じた獲得バッジを動的に取得
  def current_badges
    current_streak_count = streak_count
    return Badge.none unless current_streak_count > 0
    
    Badge.streak_badges.where('required_days <= ?', current_streak_count).order(:required_days)
  end
  
  alias badges current_badges
end
