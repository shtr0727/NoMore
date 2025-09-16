class Badge < ApplicationRecord
  # post_badgesテーブルは削除済み - バッジは動的計算で管理
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  
  # バッジの種類
  BADGE_TYPES = {
    'streak' => '継続日数バッジ',
    'achievement' => '達成バッジ',
    'special' => '特別バッジ'
  }.freeze
  
  validates :badge_type, inclusion: { in: BADGE_TYPES.keys }
  
  # 継続日数バッジ用のスコープ
  scope :streak_badges, -> { where(badge_type: 'streak') }
  
  # 継続日数バッジかどうかを判定
  def streak_badge?
    badge_type == 'streak'
  end
  
  # 必要継続日数を満たしているかチェック
  def earned_by_streak?(streak_count)
    return false unless streak_badge?
    streak_count >= required_days
  end
end
